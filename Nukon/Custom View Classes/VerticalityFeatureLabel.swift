//
//  VerticalityFeatureLabel.swift
//  Nukon
//
//  Created by Chris Mauldin on 2/27/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

@IBDesignable class VerticalityFeatureLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var angle: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        
        let radians = angle * CGFloat(Double.pi) / 180
        
        let x1 = cos(radians) * 0.5 + 0.5 // 0 to 1
        let x2 = 1 - x1
        let y1 = sin(radians) * 0.5 + 0.5
        let y2 = 1 - y1
                
        self.setNeedsDisplay()
    }

}
