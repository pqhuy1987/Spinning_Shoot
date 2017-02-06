//
//  GameCenterManager.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import GameKit

/**
 Manager for accessing game center.
 */
open class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    open static let sharedManager = GameCenterManager()       // singleton instance
    
    fileprivate var presentingViewController: UIViewController?     // UIViewController on which the GC-VC is presented
    
    fileprivate let GameCenterScoreLeaderboardIdentifier = "spinning-shots_leaderboard_score"   // leaderboard identifier
    
    /**
        Assign the presenting view controller and authenticate the local player.
    */
    open func setup(withPresentingViewController viewController: UIViewController) {
        presentingViewController = viewController
        authenticatePlayer()
    }
    
    /**
     Report a score to the leaderboard.
     - parameter score: score to report
     */
    open func reportScore(_ score: Int) {
        let gkScore = GKScore(leaderboardIdentifier: GameCenterScoreLeaderboardIdentifier)
        gkScore.value = Int64(score)
        
        GKScore.report([gkScore], withCompletionHandler: { (error) -> Void in
            if error != nil { print("Error while reporting score") }
        }) 
    }
    
    /**
     Show the GameCenter Leaderboard ViewController
     */
    open func showLeaderboards() {
        let gcController = GKGameCenterViewController()
        gcController.gameCenterDelegate = self
        gcController.viewState = .leaderboards
        
        guard let presentingViewController = presentingViewController else {
            print("Error while showing GameCenter Leadboard: PresentingViewController not set")
            return
        }
        
        presentingViewController.present(gcController, animated: true, completion: nil)
    }
    
    /**
     Authenticate the local player
     */
    fileprivate func authenticatePlayer() {
        let player = GKLocalPlayer.localPlayer()
        
        player.authenticateHandler = { (viewController, error) in
            if error != nil {
                print("Error while authenticating player: \(error?.localizedDescription)")
                print(" -> error: \(error?.localizedDescription)")
            }
            
            if let presentingViewController = self.presentingViewController {
                if let viewController = viewController {
                    print("Error while authenticating player: the to-be-presented viewController is not nil and should be presented")
                    presentingViewController.present(viewController, animated: true, completion: nil)
                } else {
                    // player authentication was successful
                }
            } else {
                print("Error while authenticating player: PresentingViewController not set")
            }
        }
    }
    
    /**
     Dismiss the GameCenter Leaderboard ViewController.
     */
    open func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
