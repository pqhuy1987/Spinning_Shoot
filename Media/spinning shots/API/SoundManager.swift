//
//  SoundManager.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit
import AVFoundation

/**
 Available sounds to play.
 */
public enum Sound {
    case hit
    case miss
    case heart
    
    public static var allSounds = [hit, miss, heart]
    
    public var fileName: String {
        switch self {
        case .hit: return "sfx-hit.wav"
        case .miss: return "sfx-miss.wav"
        case .heart: return "sfx-heart.wav"
        }
    }
}

/**
 Global Sound Manager.
 */
open class SoundManager {
    open static let sharedManager = SoundManager()    // singleton instance
    
    fileprivate(set) open var  scene: SKScene?            // scene used to play the sounds
    fileprivate var soundActions = [Sound : SKAction]()     // sounds to play
    
    fileprivate init() {
        // NOTE:    Do not uncomment yet, because the sounds are not yet added to the project.
        //          App will crash when trying to load them ;)
        //initSounds() // TODO: uncomment for prod
    }
    
    /**
     Assign a scene on which the sounds should be played.
     - parameter scene: scene to be used for playback
     */
    open func setup(_ scene: SKScene) {
        self.scene = scene
    }
    
    /**
     Load all sound actions.
     */
    fileprivate func initSounds() {
        soundActions = [:]
        for sound in Sound.allSounds {
            soundActions[sound] = actionForSound(sound)
        }
    }
    
    /**
     Load a specific sound action.
     */
    fileprivate func actionForSound(_ sound: Sound) -> SKAction {
        return SKAction.playSoundFileNamed(sound.fileName, waitForCompletion: false)
    }
    
    /**
     Play a sound.
     - parameter sound: sound to be played
     */
    open func playSound(_ sound: Sound) {
        // check whether music playback is enabled in Settings and whether the sound is actually loaded
        guard Settings.sharedManager.isMusicEnabled == true, let scene = scene, let soundAction = soundActions[sound] else { return }
        scene.run(soundAction)
    }
}
