//
//  LineNode.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-22.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Orientation a line can be in.
 */
public enum LineOrientation {
    case horizontal
    case vertical
}

/**
 Node showing a simple line.
 */
open class LineNode: SKShapeNode {
    
    /**
     Create a line node.
     - parameter length: length of the line
     - parameter orientation: orientation of the line
     */
    public init(length: CGFloat, orientation: LineOrientation) {
        // draw the path of the line
        // - the line's middle is in the node's center
        let linePath = CGMutablePath()
        let half = length / 2.0
        
        let x1, x2: CGFloat
        let y1, y2: CGFloat
        
        switch orientation {
        case .horizontal:
            x1 = -half
            y1 = 0.0
            
            x2 = half
            y2 = 0.0
        case .vertical:
            x1 = 0.0
            y1 = -half
            
            x2 = 0.0
            y2 = half
        }
        
        linePath.move(to: CGPoint (x: x1, y: y1))
        linePath.move(to: CGPoint (x: x2, y: y2))
        
        super.init()
        
        path = linePath
        strokeColor = Colors.Clear
        lineWidth = 2.0
        
        // create the physics body for the collision detection
        // -> chose a rectangle body with a height of 1 because a simple line body didn't work (collision not detected)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: length, height: 1.0), center: position)
        physicsBody?.categoryBitMask = EntityType.collisionMarker.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = EntityType.target.rawValue
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

