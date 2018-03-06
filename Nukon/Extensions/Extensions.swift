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
    
}

extension UIButton {
    
    func animateShadow() {
        layer.shadowColor = UIColor.redSun.cgColor
        layer.shadowRadius = 15
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = layer.shadowOpacity
        
        animation.toValue = 1
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = CFloat.infinity

        layer.add(animation, forKey: "shadowPulsingEffect")
    }
    
    func stopAnimating() {
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
}
