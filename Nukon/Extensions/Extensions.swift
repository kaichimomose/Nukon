//
//  Extensions.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/1/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
    
    static let redSun = UIColor.rgb(r: 242, g: 110, b: 108)
    
    
    static let lavender = UIColor.rgb(r: 214, g: 143, b: 214)
    
    
    static let aqua = UIColor.rgb(r: 124, g: 222, b: 220)
    
    
    static let peach = UIColor.rgb(r: 234, g: 185, b: 185)
    
    //background color
    static let hiraganaBackground = rgb(r: 179, g: 205, b: 253)
    static let katakanaBackground = rgb(r: 239, g: 168, b: 218)
    
    //colors for study recognition
    static let materialOrange = UIColor.rgb(r: 275, g: 279, b: 115)
    
    static let materialYellow = UIColor.rgb(r: 255, g: 225, b: 115)
    
    static let materialGreen = UIColor.rgb(r: 115, g: 255, b: 115)
    
    static let materialLightGreen = UIColor.rgb(r: 199, g: 255, b: 115)
    
    static let materialBeige = UIColor.rgb(r: 244, g: 241, b: 222)
    
}

extension UIButton {
    
    func animateShadow(pulsing: Bool) {
        layer.shadowColor = UIColor.redSun.cgColor
        layer.shadowRadius = 15
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = layer.shadowOpacity
        
        animation.toValue = 1
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = CFloat.infinity
        
        if pulsing == false {
            animation.toValue = 0
            animation.duration = 0
            animation.autoreverses = false
            animation.repeatCount = 0
        }

        layer.add(animation, forKey: "shadowPulsingEffect")
    }
}
