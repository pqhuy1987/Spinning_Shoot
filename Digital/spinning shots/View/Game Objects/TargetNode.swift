//
//  TargetNode.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import SpriteKit

/**
 Visual representation of a target entity.
 */
open class TargetNode: SKShapeNode {
    
    open var target: Target
    open var shouldRotate: Bool
    
    fileprivate let startAngle: CGFloat
    fileprivate let endAngle: CGFloat
    fileprivate let radius: CGFloat
    
    /**
     Create a target node.
     - parameter target: model reprentation of the target
     - parameter thickness: stroke width
     - parameter diameter: diameter of this arc's circle
     */
    public init(target: Target, thickness: CGFloat, inRectWithDiameter diameter: CGFloat) {
        self.target = target
        self.shouldRotate = false
        
        self.radius = diameter / 2.0 - thickness / 2.0
        
        // calculate the start and end angles for the node according to the target's rotation
        self.startAngle = (0.0 + target.rotation - target.degrees / 2.0) * CGFloat(M_PI)/180
        self.endAngle = (target.degrees + target.rotation - target.degrees / 2.0) * CGFloat(M_PI)/180
        
        super.init()
        path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        
        strokeColor = Colors.Target
        lineWidth = thickness
        
        
        // create a  physicsBody for the collision detection
        //
        // since the node is actually just a bent line with a thick stroke,
        // we need to manually create two physic bodies along the top and bottom of the stroke
        let outerPhysicsBody = physicsBodyWithRadius(diameter / 2.0)
        let innerPhysicsBody = physicsBodyWithRadius(diameter / 2.0 - thickness)
        
        physicsBody = SKPhysicsBody(bodies: [outerPhysicsBody, innerPhysicsBody])
        physicsBody?.categoryBitMask = EntityType.target.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = EntityType.collisionMarker.rawValue
        
        zPosition = ZPositions.Target
    }
    
    /**
     Create a physics body for the arc.
     - parameter r: radius of the arc
     */
    fileprivate func physicsBodyWithRadius(_ r: CGFloat) -> SKPhysicsBody {
        return SKPhysicsBody(edgeChainFrom: UIBezierPath(arcCenter: .zero, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
