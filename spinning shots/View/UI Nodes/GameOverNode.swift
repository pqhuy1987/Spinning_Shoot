//
//  GameOverNode.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Node containing the UI elements for the game over scene state.
 */
open class GameOverNode: SKNode {
    fileprivate var sceneDelegate: SceneTransitionDelegate  // delegate used to inform the scene about transitions
    
    fileprivate var score: Int                              // the game's end score
    fileprivate var bestScore: Int                          // the users's best score
    
    fileprivate var titleLabel: LabelNode!                  // label displaying the game over title
    fileprivate var scoreLabel: LabelNode!                  // label displaying the score
    fileprivate var scoreTitleLabel: LabelNode!             // label displaying the score title
    fileprivate var bestScoreLabel: LabelNode!              // label displaying the best score
    fileprivate var bestScoreTitleLabel: LabelNode!         // label displaying the best score title
    
    fileprivate var homeButton: ButtonNode!                 // button for switching to the menu state
    fileprivate var shareButton: ButtonNode!                // button for sharing the score
    fileprivate var gamecenterButton: ButtonNode!           // button for launching game center
    
    fileprivate var isTransitionRunning = false             // indicates whether the closing transition is running
    
    fileprivate let sizes = Values.sharedValues.sizes
    fileprivate let positions = Values.sharedValues.positions
    
    /**
     Create a game over node.
     - parameter sceneDelegate: delegate to be informed about transitions
     */
    public init(sceneDelegate: SceneTransitionDelegate, score: Int) {
        self.sceneDelegate = sceneDelegate
        self.score = score
        self.bestScore = Settings.sharedManager.bestScore
        
        super.init()
        zPosition = ZPositions.UINode
        
        setupUI()
    }
    
    /**
     Set up the UI.
     
     This method first creates the elements and then animates them in.
     */
    fileprivate func setupUI() {
        let titleFontSize = sizes.Screen.height * 0.075
        
        // add the UI elements
        titleLabel = LabelNode(text: "Game Over", fontSize: titleFontSize)
        titleLabel.name = "titleLabel"
        titleLabel.fontColor = Colors.Target
        let titleLabelPosY = sizes.Screen.height - titleLabel.frame.height / 2.0 - 32.0
        titleLabel.position = CGPoint(x: sizes.Screen.middle.x, y: titleLabelPosY)
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.alpha = 0.0
        titleLabel.setScale(0.0)
        addChild(titleLabel)
        
        let scoreLabelPosAfterTransition = positions.ScreenMiddle
        let scoreLabelPosBeforeTransition = CGPoint(x: scoreLabelPosAfterTransition.x - sizes.Screen.width, y: scoreLabelPosAfterTransition.y)
        scoreLabel = LabelNode(text: "\(score)", fontSize: titleFontSize * 1.5)
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontColor = Colors.Target
        scoreLabel.position = scoreLabelPosBeforeTransition
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .bottom
        addChild(scoreLabel)
        
        let scoreTitleLabelPosAfterTransition = CGPoint(x: scoreLabelPosAfterTransition.x, y: scoreLabelPosAfterTransition.y + scoreLabel.frame.height + 2.0)
        let scoreTitleLabelPosBeforeTransition = CGPoint(x: scoreTitleLabelPosAfterTransition.x - sizes.Screen.width, y: scoreTitleLabelPosAfterTransition.y)
        scoreTitleLabel = LabelNode(text: "SCORE", fontSize: titleFontSize * 0.75)
        scoreTitleLabel.name = "scoreTitleLabel"
        scoreTitleLabel.fontColor = Colors.Target
        scoreTitleLabel.position = scoreTitleLabelPosBeforeTransition
        scoreTitleLabel.horizontalAlignmentMode = .center
        scoreTitleLabel.verticalAlignmentMode = .bottom
        addChild(scoreTitleLabel)
        
        let bestScoreTitleLabelPosAfterTransition = CGPoint(x: scoreLabelPosAfterTransition.x, y: scoreLabelPosAfterTransition.y - 2.0)
        let bestScoreTitleLabelPosBeforeTransition = CGPoint(x: bestScoreTitleLabelPosAfterTransition.x + sizes.Screen.width, y: bestScoreTitleLabelPosAfterTransition.y)
        bestScoreTitleLabel = LabelNode(text: "BEST", fontSize: titleFontSize * 0.45)
        bestScoreTitleLabel.name = "bestScoreTitleLabel"
        bestScoreTitleLabel.fontColor = Colors.Target
        bestScoreTitleLabel.position = bestScoreTitleLabelPosBeforeTransition
        bestScoreTitleLabel.horizontalAlignmentMode = .center
        bestScoreTitleLabel.verticalAlignmentMode = .top
        addChild(bestScoreTitleLabel)
        
        let bestScoreLabelPosAfterTransition = CGPoint(x: bestScoreTitleLabelPosAfterTransition.x, y: bestScoreTitleLabelPosAfterTransition.y - bestScoreTitleLabel.frame.height - 2.0)
        let bestScoreLabelPosBeforeTransition = CGPoint(x: bestScoreLabelPosAfterTransition.x + sizes.Screen.width, y: bestScoreLabelPosAfterTransition.y)
        bestScoreLabel = LabelNode(text: "\(bestScore)", fontSize: titleFontSize * 0.95)
        bestScoreLabel.name = "bestScoreLabel"
        bestScoreLabel.fontColor = Colors.Target
        bestScoreLabel.position = bestScoreLabelPosBeforeTransition
        bestScoreLabel.horizontalAlignmentMode = .center
        bestScoreLabel.verticalAlignmentMode = .top
        addChild(bestScoreLabel)
        
        homeButton = ButtonNode(item: .home)
        homeButton.name = "homeButton"
        homeButton.position = positions.GameOverHomeButton
        homeButton.alpha = 0.0
        homeButton.setScale(0.0)
        addChild(homeButton)
        
        shareButton = ButtonNode(item: .share)
        shareButton.name = "shareButton"
        shareButton.position = positions.GameOverShareButton
        shareButton.alpha = 0.0
        shareButton.setScale(0.0)
        addChild(shareButton)
        
        gamecenterButton = ButtonNode(item: .gameCenter)
        gamecenterButton.name = "gamecenterButton"
        gamecenterButton.position = positions.GameOverGameCenterButton
        gamecenterButton.alpha = 0.0
        gamecenterButton.setScale(0.0)
        addChild(gamecenterButton)
        
        // animate the elements in
        let moveScore = SKAction.move(to: scoreLabelPosAfterTransition, duration: ActionDuration)
        let moveScoreTitle = SKAction.move(to: scoreTitleLabelPosAfterTransition, duration: ActionDuration)
        let moveBestScore = SKAction.move(to: bestScoreLabelPosAfterTransition, duration: ActionDuration)
        let moveBestScoreTitle = SKAction.move(to: bestScoreTitleLabelPosAfterTransition, duration: ActionDuration)
        scoreLabel.run(moveScore)
        scoreTitleLabel.run(moveScoreTitle)
        bestScoreLabel.run(moveBestScore)
        bestScoreTitleLabel.run(moveBestScoreTitle)
        
        titleLabel.run(SKAction.fadeInAndScaleUp(ActionDuration))
        homeButton.run(SKAction.fadeInAndScaleUp(ActionDuration))
        shareButton.run(SKAction.fadeInAndScaleUp(ActionDuration))
        gamecenterButton.run(SKAction.fadeInAndScaleUp(ActionDuration))
    }
    
    /**
     Close this UI node and transition to another state.
     - parameter targetState: state the scene shoul transition to
     */
    open func close(withTargetState targetState: SceneState) {
        isTransitionRunning = true
        
        // This is a 2-step animation/transition
        // 1. fade/scale out the title and buttons
        // -> when 1. is finished:
        // 2. move score labels out of screen bounds
        
        // create and run fade+scale animation actions
        let fadeOut = SKAction.fadeOut(withDuration: ActionDuration)
        let fadeOutAndPop = SKAction.group([fadeOut, SKAction.popAction])
        
        titleLabel.run(fadeOutAndPop)
        homeButton.run(fadeOutAndPop)
        shareButton.run(fadeOutAndPop)
        gamecenterButton.run(fadeOutAndPop)
        
        // create label-move animation actions
        let moveToRight = SKAction.moveBy(x: sizes.Screen.width, y: 0.0, duration: ActionDuration)
        let moveToLeft = SKAction.moveBy(x: -sizes.Screen.width, y: 0.0, duration: ActionDuration)
        let groupAction = SKAction.group([
            SKAction.run(moveToRight, onChildWithName: scoreLabel.name!),
            SKAction.run(moveToRight, onChildWithName: scoreTitleLabel.name!),
            SKAction.run(moveToLeft, onChildWithName: bestScoreLabel.name!),
            SKAction.run(moveToLeft, onChildWithName: bestScoreTitleLabel.name!)
            ])
        
        // chain animations
        let sequenceAction = SKAction.sequence([
            SKAction.wait(forDuration: ActionDuration),
            groupAction
            ])
        
        // start transition with animations
        startClosingTransition(withAction: sequenceAction, targetState: targetState)
    }
    
    /**
     Perform the closing animations and inform the delegate about the completion of the transition.
     - parameter action: animation action to be performed
     - parameter targetState: state to transition to
     */
    fileprivate func startClosingTransition(withAction action: SKAction, targetState: SceneState) {
        let wait = SKAction.wait(forDuration: ActionDuration)
        let block = SKAction.run {
            self.sceneDelegate.completedTransitionFromState(.gameOver, andShouldNowSwitchToState: targetState)
        }
        run(SKAction.sequence([action, wait, block]))
    }
    
    /**
     Send a notification to share the score.
     
     The listener for this notification should be added to the main ViewController.
     
     - parameter touchLocationString: string representation of the touched location
     */
    fileprivate func shareScore(_ touchLocationString: String) {
        let buttonSize = NSStringFromCGSize(shareButton.frame.size)
        let info = ["Score" : score, "TouchLocation" : touchLocationString, "ButtonSize" : buttonSize] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShareScore"), object: self, userInfo: info as [AnyHashable: Any])
    }
    
    /**
     Process touches on this UI node.
     */
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // only process touches if not currently transitioning to another state.
        guard !isTransitionRunning else { return }
        
        let location = touches.first!.location(in: self)
        
        // check whether an UI element was touched
        if homeButton.frame.contains(location) {
            // home button was touched
            // -> close this node and switch to menu state
            close(withTargetState: .menu)
        } else if shareButton.frame.contains(location) {
            // share button was touched
            // -> share score
            shareButton.run(SKAction.tapAction)
            shareScore(NSStringFromCGPoint(location))
        } else if gamecenterButton.frame.contains(location) {
            // gamecenter button was touched
            // -> open game center
            gamecenterButton.run(SKAction.tapAction)
            GameCenterManager.sharedManager.showLeaderboards()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
}
