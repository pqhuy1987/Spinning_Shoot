//
//  MenuNode.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Node containing the UI elements for the menu scene state.
 */
open class MenuNode: SKNode {
    
    fileprivate var sceneDelegate: SceneTransitionDelegate      // delegate used to inform the scene about transitions
    
    fileprivate var playButton: ButtonNode!                     // button for switching to the playing state
    
    fileprivate var isTransitionRunning = false                 // indicates whether the closing transition is running
    
    /**
    Create a menu node.
    - parameter sceneDelegate: delegate to be informed about transitions
    */
    public init(sceneDelegate: SceneTransitionDelegate) {
        self.sceneDelegate = sceneDelegate
        
        super.init()
        zPosition = ZPositions.UINode
        
        setupUI()
    }
    
    /**
     Set up the UI.
     
     This method first creates the elements and then animates them in.
     */
    fileprivate func setupUI() {
        // add the UI elements
        playButton = ButtonNode(item: .play)
        playButton.name = "playButton"
        playButton.position = Values.sharedValues.sizes.Screen.middle
        playButton.alpha = 0.0
        playButton.setScale(0.0)
        addChild(playButton)
        
        // animate the elements in with a fade and scale action
        let fadeIn = SKAction.fadeIn(withDuration: ActionDuration)
        let scaleUp = SKAction.scale(to: 1.0, duration: ActionDuration)
        let fadeInAndScaleUp = SKAction.group([fadeIn, scaleUp])
        playButton.run(fadeInAndScaleUp)
    }
    
    /**
     Close this UI node and transition to another state.
     - parameter targetState: state the scene shoul transition to
     */
    open func close(withTargetState targetState: SceneState) {
        isTransitionRunning = true
        
        // create animation actions
        let fadeOut = SKAction.fadeOut(withDuration: ActionDuration)
        let fadeOutAndPop = SKAction.group([fadeOut, SKAction.popAction])
        let groupAction = SKAction.group([
            SKAction.run(SKAction.group([fadeOutAndPop]), onChildWithName: playButton.name!)
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
            self.sceneDelegate.completedTransitionFromState(.menu, andShouldNowSwitchToState: targetState)
        }
        run(SKAction.sequence([action, wait, block]))
    }
    
    /**
     Process touches on this UI node.
     */
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // only process touches if not currently transitioning to another state.
        guard !isTransitionRunning else { return }
        
        let location = touches.first!.location(in: self)
        
        // check whether an UI element was touched
        if playButton.frame.contains(location) {
            // play button was touched
            // -> close this node and switch to playing state
            close(withTargetState: .playing)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)not implemented")
    }
    
}
