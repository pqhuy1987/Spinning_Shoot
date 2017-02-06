//
//  Game.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import Foundation

/**
 Defines the messages sent to a game delegate over the lifetime of a game round.
 */
public protocol GameDelegate {
    func gameDidStart()                                                     // called when a new game starts
    func gameDidEnd(_ score: Int)                                             // called when a game ends
    
    func gameDidProceedToStage(_ stage: Int)                                  // called when the game proceeds to the next stage
    func gameDidScore(_ newScore: Int)                                        // called when the game's score changed
    func gameDidChangeAmountOfBullets(_ byAmount: Int, totalAmount: Int)      // called when the game's amount of bullets changed
}

/**
 The core, holding and controlling the main game values and actions.
 */
open class Game {
    fileprivate var isRunning = false           // indicates whether the game is running
    fileprivate(set) open var score = 0       // holds the score value
    fileprivate(set) open var stage = 1       // holds the current stage
    fileprivate(set) open var bullets = 1     // holds the current amount of bullets
    
    open var gameDelegate: GameDelegate?
    
    /**
     Create a game with default values
     */
    public init() {}
    
    /**
     Start a new game and reset all values.
     */
    open func startNewGame() {
        score = 0
        stage = 1
        bullets = 1
        isRunning = true
        
        gameDelegate?.gameDidStart()
    }
    
    /**
     End the current game.
     */
    open func endGame() {
        isRunning = false
        
        gameDelegate?.gameDidEnd(score)
    }
    
    /**
     Increase the score by one point and add another bullet.
     */
    open func increaseScore() {
        score += 1
        addBullet()
        
        gameDelegate?.gameDidScore(score)
    }
    
    /**
     Decrease the amount of bullets by one.
     */
    open func shootBullet() {
        bullets -= 1
        
        gameDelegate?.gameDidChangeAmountOfBullets(-1, totalAmount: bullets)
    }
    
    /**
     Increase the amount of bullets by one.
     */
    open func addBullet() {
        bullets += 1
        
        gameDelegate?.gameDidChangeAmountOfBullets(1, totalAmount: bullets)
    }
    
    /**
     Increase the stage counter.
     */
    open func nextStage() {
        stage += 1
        
        gameDelegate?.gameDidProceedToStage(stage)
    }
    
    /**
     Perform actions on every game tick.
     */
    open func tick(_ timeDelta: TimeInterval) {
        
    }
}
