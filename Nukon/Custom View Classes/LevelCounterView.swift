//
//  LevelCounterView.swift
//  Nukon
//
//  Created by Chris Mauldin on 12/3/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

//@IBDesignable
class LevelCounterView: UIView {

    private struct Constants {
        static let numberOfLevels = 46
        static let lineWidth: CGFloat = 10
        static let arcWidth: CGFloat = 15
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    
    
    @IBInspectable var counter: Int = 0
    @IBInspectable var outlineColor: UIColor = UIColor.red
    @IBInspectable var counterColor: UIColor = UIColor.lightGray
    
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180.0)
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        
        //CENTER OF ARC
        let center = CGPoint(x: bounds.width / 2, y: (bounds.height / 2) + 12)
        
        
        // RADIUS
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        
        //STARTING ANGLE
        let startAngle = degreesToRadians(135)
        //ENDING ANGLE
        let endAngle = degreesToRadians(45)
        
        //CREATE ARC PATH
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2.5 - Constants.arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true
        )
        
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.lineCapStyle = .round
        path.stroke()
        
        //ANGLE BETWEEN BOTH ARCS
        let angleDifference: CGFloat = 2 * .pi - (startAngle - endAngle)
        
        //ARC LENGTH PER LEVEL
        let arcLengthPerLevel = angleDifference / CGFloat(Constants.numberOfLevels)
        
        //ANGLE OF EACH LEVEL
        let outlineEndAngle = arcLengthPerLevel * CGFloat(counter) + startAngle
        
        //DRAW PATH FOR INSIDE ARC
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: radius/2.5 - Constants.arcWidth/2,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.arcWidth
        outlinePath.lineCapStyle = .round
        outlinePath.stroke()
    }
    

}
