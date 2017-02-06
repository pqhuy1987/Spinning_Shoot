//
//  PlayingNode.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Node containing the UI elements for the playing scene state.
 */
open class PlayingNode: SKNode {
    fileprivate var sceneDelegate: SceneTransitionDelegate  // delegate used to inform the scene about transitions
    
    fileprivate var scoreLabel: LabelNode!                  // label displaying the current score
    
    fileprivate var isTransitionRunning = false             // indicates whether the closing transition is
    
    fileprivate let sizes = Values.sharedValues.sizes
    
    /**
     Create a playing node.
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
        // Add the UI elements
        scoreLabel = LabelNode(text: "0", fontSize: sizes.PlayingScoreLabelSize)
        scoreLabel.name = "scoreLabel"
        let scoreLabelPosY = sizes.Screen.height - scoreLabel.frame.height / 2.0 - 32.0
        scoreLabel.position = CGPoint(x: sizes.Screen.middle.x, y: scoreLabelPosY)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.alpha = 0.0
        scoreLabel.setScale(0.0)
        addChild(scoreLabel)
        
        // animate the elements in with a fade and scale action
        let fadeIn = SKAction.fadeIn(withDuration: ActionDuration)
        let scaleup = SKAction.scale(to: 1.0, duration: ActionDuration)
        let fadeInAndScaleUp = SKAction.group([fadeIn, scaleup])
        scoreLabel.run(fadeInAndScaleUp)
    }
    
    /**
     Update the label text.
     - parameter score: score to display
     */
    open func updateScoreLabel(withScore score: Int) {
        scoreLabel.text = "\(score)"
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
            SKAction.run(SKAction.group([fadeOutAndPop]), onChildWithName: scoreLabel.name!)
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
            self.sceneDelegate.completedTransitionFromState(.playing, andShouldNowSwitchToState: targetState)
        }
        run(SKAction.sequence([action, wait, block]))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
}
