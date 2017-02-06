//
//  BulletNode.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Visual representation of a bullet entity.
 */
open class BulletNode: SKSpriteNode {
    
    open var bullet: Bullet
    
    /**
     Create a bullet node
     */
    public init() {
        self.bullet = Bullet()
        let texture = Textures.sharedTextures.Bullet
        let textureSize = texture.size()
        super.init(texture: texture, color: Colors.Clear, size: textureSize)
        
        // create a  physicsBody for the collision detection
        physicsBody = SKPhysicsBody(rectangleOf: textureSize, center: .zero)
        physicsBody?.categoryBitMask = EntityType.bullet.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = EntityType.target.rawValue
        
        zPosition = ZPositions.Bullet
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
