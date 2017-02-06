//
//  Textures.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Global access to the game's textures via a singleton instance.
 
 Textures are loaded on the first access of the singleton instance.
 */
open class Textures {
    open static let sharedTextures = Textures()
    
    open let Cannon: SKTexture
    open let Bullet: SKTexture
    
    fileprivate let PlayButton: SKTexture
    fileprivate let HomeButton: SKTexture
    fileprivate let ShareButton: SKTexture
    fileprivate let GameCenterButton: SKTexture
    
    let sizes = Values.sharedValues.sizes
    
    /**
     Load the textures.
     */
    init() {
        Cannon = SKTexture(image: StyleKit.imageOfCannon(size: sizes.Cannon))
        Bullet = SKTexture(image: StyleKit.imageOfBullet(size: sizes.Bullet))
        
        PlayButton = SKTexture(image: StyleKit.imageOfPlayButton(diameter: sizes.MenuButtonPlayDiameter))
        HomeButton = SKTexture(image: StyleKit.imageOfHomeButton(diameter: sizes.GameOverButtonHomeDiameter))
        ShareButton = SKTexture(image: StyleKit.imageOfShareButton(diameter: sizes.GameOverButtonShareDiameter))
        GameCenterButton = SKTexture(image: StyleKit.imageOfGameCenterButton(diameter: sizes.GameOverButtonGameCenterDiameter))
    }
    
    /**
     Get the button texture.
     - parameter item: button item
     */
    open func buttonItem(_ item: ButtonItem) -> SKTexture {
        let texture: SKTexture
        switch item {
        case .play: texture = PlayButton
        case .home: texture = HomeButton
        case .share: texture = ShareButton
        case .gameCenter: texture = GameCenterButton
        }
        return texture
    }
}
