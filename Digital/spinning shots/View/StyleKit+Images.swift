//
//  StyleKit+Images.swift
//  spinning shots
//
//  Created by Marc Zobec on 2015-10-08.
//  Copyright © 2015 Marc Zobec. All rights reserved.
//

import UIKit

extension StyleKit {
    
    public class func imageOfCannon(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawCannon(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), cannonColor: Colors.Cannon, cannonStrokeColor: Colors.Stroke)
        
        let imageOfCannon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfCannon!
    }
    
    public class func imageOfBullet(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawBullet(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), bulletColor: Colors.Bullet)
        
        let imageOfBullet = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfBullet!
    }
    
    public class func imageOfPlayButton(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(diameter: diameter), false, 0)
        drawPlayButton(buttonFillColor: Colors.Cannon, buttonStrokeColor: Colors.Target, buttonFrameDiameter: diameter)
        
        let imageOfPlayButton = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfPlayButton!
    }
    
    public class func imageOfHomeButton(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(diameter: diameter), false, 0)
        drawHomeButton(buttonFillColor: Colors.Cannon, buttonStrokeColor: Colors.Target, buttonFrameDiameter: diameter)
        
        let imageOfHomeButton = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfHomeButton!
    }
    
    public class func imageOfShareButton(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(diameter: diameter), false, 0)
        drawShareButton(buttonFillColor: Colors.Cannon, buttonStrokeColor: Colors.Target, buttonFrameDiameter: diameter)
        
        let imageOfShareButton = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfShareButton!
    }
    
    public class func imageOfGameCenterButton(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(diameter: diameter), false, 0)
        drawGameCenterButton(buttonFillColor: Colors.Cannon, buttonStrokeColor: Colors.Target, buttonFrameDiameter: diameter)
        
        let imageOfGameCenterButton = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfGameCenterButton!
    }
    
}
