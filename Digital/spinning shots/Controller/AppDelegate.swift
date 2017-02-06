//
//  AppDelegate.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var gameVC: ViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        
        // preload stuff
        Values.sharedValues
        Textures.sharedTextures
        
        gameVC = ViewController()
        window.rootViewController = gameVC
        window.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        gameVC?.scene.isPaused = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        gameVC?.scene.isPaused = false
    }
    
}

