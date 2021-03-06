//
//  Scene.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 States the Scene can be in.
 */
public enum SceneState: Int {
    case menu, playing, gameOver
}

/**
 Conforming types are informed about scene transition changes.
 */
public protocol SceneTransitionDelegate {
    func completedTransitionFromState(_ fromState: SceneState, andShouldNowSwitchToState toState: SceneState)
}

/**
 Directions the game objects can rotate to.
 */
public enum RotationDirection: Int {
    case clockwise = -1
    case counterClockwise = 1
    
    public mutating func flip() {
        self = (self == .clockwise ? .counterClockwise : .clockwise)
    }
}

/**
 Core visual & interaction layer of the game.
 Controls the game via a Game instance.
 */
open class Scene: SKScene {
    
    //MARK: - Variables
    fileprivate var menuNode: MenuNode?                     // holds the menu state UI
    fileprivate var playingNode: PlayingNode?               // holds the playing state UI
    fileprivate var gameOverNode: GameOverNode?             // holds the game over state UI
    
    fileprivate var sceneState: SceneState!                 // keeps track of the scene's current state
    fileprivate var game: Game!                             // game instance
    
    fileprivate var isGameRunning = false                   // indicates whether the game is running
    fileprivate var lastUpdateTime: TimeInterval = 0.0    // helper for the update-time calculating
    fileprivate var dt: TimeInterval = 0.0                // indicates the time delta between now and the last update
    
    fileprivate var backgroundNode: BackgroundNode!         // background of the scene
    fileprivate var borderNode: OvalBorderNode!             // border of the playing area
    fileprivate var collisionLineNode: LineNode!                     // invisible, used for collision detection
    
    fileprivate var rotationNode: SKNode!                   // holds all game objects that should rotate
    fileprivate var objectsNode: SKNode!                    // holds the rotation node + all game objects that shouldn't rotate
    
    fileprivate var cannonNode: CannonNode!                 // cannon
    fileprivate var bulletNode: BulletNode!                 // bullet
    fileprivate var currentPatternNodes: [TargetNode] = []  // target nodes
    
    fileprivate var shouldReloadBulletOnNextUpdate = false  // indicates whether the cannon should be reloaded on the next update
    fileprivate var rotationDirection: RotationDirection!   // indicates the rotation direction
    
    //MARK: - Constants
    fileprivate let sizes = Values.sharedValues.sizes
    fileprivate let positions = Values.sharedValues.positions
    fileprivate let speeds = Values.sharedValues.speeds
    
    //MARK: - View Lifecycle
    open override func didMove(to view: SKView) {
        setupOnLaunch()
        
        switchToState(.menu)
    }
    
    //MARK: - Setup
    
    /**
    Initial scene setup.
    */
    fileprivate func setupOnLaunch() {
        setupGameInstance()
        setupBackgroundNode()
        setupObjectsNode()
        setupCollisionLineNode()
        setupRotationNode()
        setupPhysics()
    }
    
    /**
     Create a game instance + connect the gameDelegate to self.
     */
    fileprivate func setupGameInstance() {
        game = Game()
        game.gameDelegate = self
    }
    
    /**
     Create the background node and add it to the scene.
     */
    fileprivate func setupBackgroundNode() {
        backgroundNode = BackgroundNode()
        backgroundNode.position = positions.ScreenMiddle
        addChild(backgroundNode)
    }
    
    /**
     Create the objects node and add it to the scene.
     */
    fileprivate func setupObjectsNode() {
        objectsNode = SKNode()
        addChild(objectsNode)
    }
    
    /**
     Create the collision line node.
     
     Note: _The node is not getting added to the scene automatically. It should be added manually once it's needed._
     */
    fileprivate func setupCollisionLineNode() {
        collisionLineNode = LineNode(length: sizes.PlayingAreaDiameter, orientation: .horizontal)
        collisionLineNode.position = positions.ScreenMiddle
    }
    
    /**
     Create the rotation node and add it to the objects node.
     */
    fileprivate func setupRotationNode() {
        rotationNode = SKNode()
        rotationNode.position = positions.ScreenMiddle
        objectsNode.addChild(rotationNode)
    }
    
    /**
     Configure the physics world.
     */
    fileprivate func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
    }
    
    /**
     Create a new game
     
     - parameter completion: Executed when game setup is completed (incl. animations).
     */
    fileprivate func setupNewGame(completion: @escaping () -> Void) {
        setupCannonNode()
        setupBulletNode()
        
        setupBorderNode()
        
        // Initial game object animations:
        // - fade in & scale up cannon
        // - move bullet up to make it stick out of the cannon a bit
        let cannonAction = SKAction.fadeInAndScaleUp(ActionDuration)
        let bulletAction = SKAction.move(to: positions.CannonBullet, duration: ActionDuration / 3.0)
        
        borderNode.run(SKAction.fadeAlpha(to: 0.25, duration: ActionDuration))
        cannonNode.run(cannonAction, completion: {
            self.objectsNode.addChild(self.bulletNode)
            self.bulletNode.run(bulletAction)
        }) 
        
        // Calculate the total duration of the running actions
        let totalInitDuration = cannonAction.duration + bulletAction.duration
        
        // Wait for the actions to be completed, then execute the completion closure
        run(SKAction.sequence([
            SKAction.wait(forDuration: totalInitDuration),
            SKAction.run(completion)
            ]))
    }
    
    /**
     Create the cannon node and add it to the objects node.
     */
    fileprivate func setupCannonNode() {
        cannonNode = CannonNode()
        cannonNode.alpha = 0.0
        cannonNode.setScale(0.0)
        cannonNode.position = positions.Cannon
        objectsNode.addChild(cannonNode)
    }
    
    /**
     Create the bullet node.
     
     Note: _The node is not getting added to the objects node automatically._
     */
    fileprivate func setupBulletNode() {
        bulletNode = BulletNode()
        bulletNode.position = positions.Cannon
    }
    
    /**
     Create the border node and add it to the objects node.
     */
    fileprivate func setupBorderNode() {
        borderNode = OvalBorderNode(diameter: sizes.BorderDiameter, strokeWidth: sizes.BorderStrokeWidth)
        borderNode.alpha = 0.0
        borderNode.position = positions.OvalBorderNode
        objectsNode.addChild(borderNode)
    }
    
    /**
     Adds a pattern of target nodes to the rotation node.
     
     - parameter pattern: The pattern to load
     */
    fileprivate func loadPattern(_ pattern: TargetPattern) {
        // clear out possible current nodes
        currentPatternNodes.removeAll()
        
        // create target nodes for the given pattern
        currentPatternNodes = TargetNodeCreator.create(pattern)
        
        // animate the node loading
        // - add each node with alpa = 0.0 to rotation node
        // - fade in each node with a growing delay
        let waitTime = 0.05
        for (index, arc) in currentPatternNodes.enumerated() {
            arc.alpha = 0.0
            rotationNode.addChild(arc)
            
            let wait = SKAction.wait(forDuration: waitTime * Double(index))
            let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: ActionDuration)
            arc.run(SKAction.sequence([wait, fadeIn]))
        }
        
        // once all nodes are faded in, tell them to start rotating
        let totalWait = SKAction.wait(forDuration: waitTime * Double(currentPatternNodes.count + 1))
        run(SKAction.sequence([totalWait, SKAction.run {
            self.currentPatternNodes.forEach { $0.shouldRotate = true }
            }]))
    }
    
    //MARK: - Game Loop
    
    /**
    Sets up a new game.
    */
    open func startNewGame() {
        setupNewGame(completion: {
            self.game.startNewGame()
        })
    }
    
    /**
     Performs any scene-specific updates that need to occur before scene actions are evaluated.
     - parameter currentTime: The current system time
     */
    open override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // calculate time delta since last update, limit to 30fps
        // TODO: fix calculation, upgrade to 60fps
        dt =  lastUpdateTime > 0 ? currentTime - lastUpdateTime : 0.0
        if dt > 1.0/30.0 {
            dt = 1.0/30.0
        }
        lastUpdateTime = currentTime
        
        // target nodes can be rotating even if the game isn't in playing state
        rotateTargetNodes()
        
        // check if game is running, only continue when it is
        guard isGameRunning else { return }
        
        // perform game tick
        game.tick(dt)
        
        // check if the cannon should be reloaded & move bullets
        reloadBulletIfNeeded()
        moveBullet()
    }
    
    /**
     Move the bullet if needed.
     */
    fileprivate func moveBullet() {
        // bullet should be moved if it was shot
        guard bulletNode.bullet.wasShot else { return }
        
        bulletNode.moveBy(CGPoint(x: 0, y: speeds.Bullet), dt: dt)
        
        // remove bullet if it reaches the playing area's bounds without touching a target
        if bulletNode.position.y > positions.ScreenMiddle.y + sizes.PlayingAreaDiameter / 2.0 - bulletNode.size.height / 2.0 {
            bulletNode.removeFromParent()
            
            // end the game if the player hasn't anymore bullets
            if game.bullets == 0 {
                game.endGame()
            }
        }
    }
    
    /**
     Rotate the target nodes.
     */
    fileprivate func rotateTargetNodes() {
        // rotate each of the current nodes where shouldRotate is set to true
        for targetNode in currentPatternNodes where targetNode.shouldRotate == true {
            let direction = CGFloat(rotationDirection.rawValue)
            targetNode.zRotation += CGFloat(dt) * speeds.Target * direction
        }
    }
    
    //MARK: - Game Actions
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // handle touches depending on the scene's current state
        // - menu & game over: forward touches to their UI node
        // - playing: shoot bullet
        switch sceneState as SceneState {
        case .menu: menuNode?.touchesBegan(touches, with: event)
        case .playing: if isGameRunning { shootBullet() }
        case .gameOver: gameOverNode?.touchesBegan(touches, with: event)
        }
    }
    
    /**
     Shoot a bullet
     */
    fileprivate func shootBullet() {
        // a bullet can only be shot if the player has at least one bullet left in his magazine
        // and if no other bullet is currently being shot (can only shoot one bullet at a time)
        guard game.bullets > 0 && !bulletNode.bullet.wasShot else { return }
        
        game.shootBullet()
        
        // mark bullet as shot, so it's picked up by the moveBullet routine in the update loop
        bulletNode.bullet.shoot()
    }
    
    /**
     Reload a bullet if needed.
     */
    fileprivate func reloadBulletIfNeeded() {
        guard shouldReloadBulletOnNextUpdate else { return }
        shouldReloadBulletOnNextUpdate = false
        
        // reset the bullet's state and position
        bulletNode.bullet.reload()
        bulletNode.position = positions.Cannon
        
        // animate the bullet to make it stick out of the cannon a bit
        let move = SKAction.move(to: positions.CannonBullet, duration: ActionDuration / 3.0)
        bulletNode.run(move)
    }
    
    /**
     Save the score
     - parameter score: score to be saved
     */
    fileprivate func saveScore(_ score: Int) {
        // the score only needs to be saved if it is higher then the currently saved best score
        guard score > Settings.sharedManager.bestScore else { return }
        
        //GameCenterManager.sharedManager.reportScore(score) // TODO: uncomment for prod
        Settings.sharedManager.setBestScore(score)
    }
}

//MARK: - GameDelegate
extension Scene: GameDelegate {
    /**
     Respond to a new game being started
     */
    public func gameDidStart() {
        // load the pattern for the first stage
        let pattern = TargetNodeCreator.patternForStage(game.stage)
        loadPattern(pattern)
        
        rotationDirection = .counterClockwise
        isGameRunning = true
    }
    
    /**
     Respond to the game being ended
     */
    public func gameDidEnd(_ score: Int) {
        isGameRunning = false
        
        // remove entities etc from ui
        objectsNode.removeAllChildren()
        rotationNode.removeAllChildren()
        
        // add empty node again
        objectsNode.addChild(rotationNode)
        
        saveScore(score)
        
        playingNode?.close(withTargetState: .gameOver)
    }
    
    /**
     Respond to the game advancing to the next stage
     */
    public func gameDidProceedToStage(_ stage: Int) {
        // check if the collision line node is needed this round
        if stage % 2 == 1 { // TODO: should be anchored in the game logic directly
            collisionLineNode.removeFromParent()
        } else {
            objectsNode.addChild(collisionLineNode)
        }
        
        // load pattern for next stage
        let pattern = TargetNodeCreator.patternForStage(stage)
        loadPattern(pattern)
    }
    
    /**
     Respond to the game changing its score
     */
    public func gameDidScore(_ newScore: Int) {
        // inform the playing UI it should update its label text
        playingNode?.updateScoreLabel(withScore: newScore)
    }
    
    /**
     Respond to the game changing its amount of bullets
     */
    public func gameDidChangeAmountOfBullets(_ byAmount: Int, totalAmount: Int) {
        if byAmount > 0 && totalAmount > 0 {
            shouldReloadBulletOnNextUpdate = true
        }
    }
}

//MARK: - Physics Delegate
extension Scene: SKPhysicsContactDelegate {
    // Respond to a collision
    public func didBegin(_ contact: SKPhysicsContact) {
        // check which two types of entities are involved in the collision
        let checkCollisionForEntityType: (_ type: EntityType) -> Bool = { (type) in
            let typeValue = type.rawValue
            return contact.bodyA.categoryBitMask == typeValue || contact.bodyB.categoryBitMask == typeValue
        }
        
        let isTargetCollision = checkCollisionForEntityType(.target)
        
        // only need to continue when a target is involved in the collision
        guard isTargetCollision else { return }
        
        let isBulletCollision = checkCollisionForEntityType(.bullet)
        let isMarkerCollision = checkCollisionForEntityType(.collisionMarker)
        
        // target collided with bullet
        // - increase score via game
        // - remove target node
        // - check if stage was cleared
        if isBulletCollision {
            // need to check if bullet was marked as hit already, because this delegate callback will be called more than once
            if !bulletNode.bullet.didHit {
                // mark bullet as hit
                bulletNode.bullet.hit()
                
                // tell the game to increase the scire
                game.increaseScore()
                
                // get & remove target node
                let targetBody: SKPhysicsBody = contact.bodyA.categoryBitMask == EntityType.target.rawValue ? contact.bodyA : contact.bodyB
                let targetNode = targetBody.node as? TargetNode
                targetNode?.removeFromParent()
                
                let index = currentPatternNodes.index(of: targetBody.node as! TargetNode)!
                currentPatternNodes.remove(at: index)
                
                // if no target nodes are left, the current stage was cleared -> advance to next one
                if currentPatternNodes.count == 0 {
                    game.nextStage()
                }
            }
        }
            // target collided with marker
            // - flip rotation direction
            // - reset collision line node
        else if isMarkerCollision {
            let markerBody: SKPhysicsBody = contact.bodyA.categoryBitMask == EntityType.collisionMarker.rawValue ? contact.bodyA : contact.bodyB
            
            // had problems with the collision being called out multiple times, so I
            // remove the physicsBody from it to prevent collision detection and add
            // it back after a small delay. TODO: tweak / find better solution
            defer {
                collisionLineNode.physicsBody = nil
            }
            
            if collisionLineNode.physicsBody != nil {
                rotationDirection.flip()
                
                let wait = SKAction.wait(forDuration: 0.2)
                let block = SKAction.run {
                    self.collisionLineNode.physicsBody = markerBody
                }
                run(SKAction.sequence([wait, block]))
            }
        }
    }
}

extension Scene: SceneTransitionDelegate {
    //MARK: - Scene Transitioning
    
    /**
    Swich to another state
    - parameter state: The desired state
    */
    fileprivate func switchToState(_ state: SceneState) {
        guard state != sceneState else { return }
        
        func switchToMenuState() {
            sceneState = .menu
            
            menuNode = MenuNode(sceneDelegate: self)
            addChild(menuNode!)
        }
        
        func switchToPlayingState() {
            sceneState = .playing
            
            playingNode = PlayingNode(sceneDelegate: self)
            addChild(playingNode!)
            
            startNewGame()
        }
        
        func switchToGameOverState() {
            sceneState = .gameOver
            
            gameOverNode = GameOverNode(sceneDelegate: self, score: game.score)
            addChild(gameOverNode!)
        }
        
        switch state {
        case .menu: switchToMenuState()
        case .playing: switchToPlayingState()
        case .gameOver: switchToGameOverState()
        }
    }
    
    /**
     Respond to the scene finishing a transition between states.
     - parameter fromState: The previous state
     - parameter toState: The new state
     */
    public func completedTransitionFromState(_ fromState: SceneState, andShouldNowSwitchToState toState: SceneState) {
        defer {
            switchToState(toState)
        }
        
        // clean up
        switch fromState {
        case .menu:
            menuNode?.removeFromParent()
            menuNode = nil
        case .playing:
            playingNode?.removeFromParent()
            playingNode = nil
        case .gameOver:
            gameOverNode?.removeFromParent()
            gameOverNode = nil
        }
    }
}
