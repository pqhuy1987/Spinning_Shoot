//
//  Settings.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import Foundation

/**
 Global Settings Manager.
 */
open class Settings {
    open static let sharedManager = Settings()                    // singleton instance
    
    // Setting Properties
    fileprivate var wasLaunchedBefore: Bool!
    fileprivate(set) open var bestScore: Int!
    fileprivate(set) open var isMusicEnabled: Bool!
    
    // Setting Property Keys
    fileprivate let SettingsLaunchedBeforeKey = "WasLaunchedBefore"
    fileprivate let SettingsBestScoreKey = "BestScore"
    fileprivate let SettingsMusicEnabledKey = "MusicEnabled"
    
    fileprivate let defaults = UserDefaults.standard
    
    /**
     Load the settings.
     */
    fileprivate init() {
        // check if this is the first launch
        self.wasLaunchedBefore = defaults.bool(forKey: SettingsLaunchedBeforeKey)
        
        if !self.wasLaunchedBefore {
            // set default values on first launch
            setBestScore(0)
            setIsMusicEnabled(true)
            
            setWasLaunchedBefore(true)
        } else {
            // assign loaded values
            self.bestScore = defaults.integer(forKey: SettingsBestScoreKey)
            self.isMusicEnabled = defaults.bool(forKey: SettingsMusicEnabledKey)
        }
    }
    
    /**
     Set whether the application was launched before and write it to NSUserDefaults.
     - parameter launchedBefore: toggle
     */
    fileprivate func setWasLaunchedBefore(_ launchedBefore: Bool) {
        self.wasLaunchedBefore = launchedBefore
        defaults.set(wasLaunchedBefore, forKey: SettingsLaunchedBeforeKey)
    }
    
    /**
     Set the best score and write it to NSUserDefaults.
     - parameter score: score to set as best
     */
    open func setBestScore(_ score: Int) {
        self.bestScore = score
        defaults.set(bestScore, forKey: SettingsBestScoreKey)
    }
    
    /**
     Set toggle whether music playbac is enabled and write it to NSUserDefaults.
     - parameter enabled: toggle
     */
    open func setIsMusicEnabled(_ enabled: Bool) {
        self.isMusicEnabled = enabled
        defaults.set(isMusicEnabled, forKey: SettingsMusicEnabledKey)
    }
}
