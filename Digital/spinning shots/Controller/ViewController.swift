//
//  ViewController.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    var scene: Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the view + scene
        let skView = SKView(frame: view.frame)
        view.addSubview(skView)
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        scene = Scene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        // TODO: uncomment for prod
        //GameCenterManager.sharedManager.setup(withPresentingViewController: self)
        //SoundManager.sharedManager.setup(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.shareScore(_:)), name: NSNotification.Name(rawValue: "ShareScore"), object: nil)
    }
    
    /**
     Share the game's score via the native share extension.
     
     Note: _Should only be called by the appropriate Notification via NSNotificationCenter, not manually.
     
     - parameter notification: The notification containing the needed information
     */
    func shareScore(_ notification: Notification) {
        // retrieve information from the notification
        let score: Int = notification.userInfo!["Score"] as! Int
        let textToShare = "I just scored \(score) points in #SpinningShots. Get the app at https://itunes.apple.com/us/app/spinning-shots/id1046883607?ls=1&mt=8"
        
        // set up a UIActivityVC for sharing the score
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        // present the VC
        // Note: this implementation contains a workaround for an iOS 8 bug on iPad with using the popoverPresentationController
        // TODO: check if workaround is still needed
        if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
            if let presentationController = activityVC.popoverPresentationController {
                let touchLocation = CGPointFromString(notification.userInfo!["TouchLocation"] as! String)
                let buttonSize = CGSizeFromString(notification.userInfo!["ButtonSize"] as! String)
                
                let tapView = UIView(frame: CGRect(x: touchLocation.x, y: view.bounds.height - touchLocation.y, width: buttonSize.width, height: buttonSize.height))
                presentationController.sourceView = tapView
            }
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
