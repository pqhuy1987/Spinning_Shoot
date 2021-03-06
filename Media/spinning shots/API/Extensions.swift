//
//  Extensions.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-06.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import UIKit
import SpriteKit

extension CGFloat {
    /**
     Get a random CGFloat in a specific range.
     - parameter firstNum: beginning of range
     - parameter secondNum: end of range
     */
    static func randomBetween(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + fmin(firstNum, secondNum)
    }
}

extension CGSize {
    /// middle point of a size.
    var middle: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }
    
    /**
     Create a square CGSize.
     - parameter diameter: size of width & length
     */
    init(diameter: CGFloat) {
        self.init(width: diameter, height: diameter)
    }
    
}

extension SKSpriteNode {
    /**
     Move the node.
     */
    func moveBy(_ velocity: CGPoint, dt: TimeInterval) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        self.position = CGPoint(x: self.position.x + amountToMove.x, y: self.position.y + amountToMove.y)
    }
}

extension SKAction {
    static var popAction: SKAction {
        let scaleUpDuration = ActionDuration / 5.0
        let scaleDownDuration = ActionDuration - scaleUpDuration
        let scaleUp = SKAction.scale(to: 1.1, duration: scaleUpDuration)
        let scaleDown = SKAction.scale(to: 0.0, duration: scaleDownDuration)
        let fadeOut = SKAction.fadeOut(withDuration: scaleDownDuration)
        let scaleSequence = SKAction.sequence([scaleUp, SKAction.group([scaleDown, fadeOut])])
        return SKAction.sequence([scaleSequence, SKAction.removeFromParent()])
    }
    
    static var tapAction: SKAction {
        let scaleUpDuration = ActionDuration / 5.0
        let scaleDownDuration = ActionDuration / 5.0
        let scaleUp = SKAction.scale(to: 1.1, duration: scaleUpDuration)
        let scaleDown = SKAction.scale(to: 1.0, duration: scaleDownDuration)
        return SKAction.sequence([scaleUp, scaleDown])
    }
    
    static func fadeInAndScaleUp(_ duration: TimeInterval) -> SKAction {
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let scaleUp = SKAction.scale(to: 1.0, duration: duration)
        return SKAction.group([fadeIn, scaleUp])
    }
}

extension UIColor {
    /**
     Create a UIColor with hex representation.
     - parameter hex: hex string
     */
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hex.hasPrefix("#") {
            let index   = hex.characters.index(hex.startIndex, offsetBy: 1)
            let hex     = hex.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    break
                }
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
