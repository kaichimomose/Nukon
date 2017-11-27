//
//  ArcView.swift
//  Nukon
//
//  Created by Chris Mauldin on 11/24/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

@IBDesignable class Arc: UIView {
    var shape = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpShapeLayer(shapeLayer: shape)
    }
    
    func setUp() {
        shape.lineWidth = 1
        shape.fillColor = UIColor.white.cgColor
        shape.strokeEnd = 1
        
        layer.addSublayer(shape)
    }
    
    func configure() {
        shape.strokeColor = UIColor.clear.cgColor
    }
    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        setUp()
//        configure()
//    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180.0)
    }
    
    func setUpShapeLayer(shapeLayer: CAShapeLayer) {
        shapeLayer.frame = self.bounds
//        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height)
//        let radius = CGFloat(self.bounds.width * 0.20)
//        let startAngle = degreesToRadians(0.0)
//        let endAngle = degreesToRadians(180.0)
//        let arcPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let arcPath = UIBezierPath()

        //starting point is top left corner
        arcPath.move(to: CGPoint(x: self.bounds.width + 3, y: self.bounds.height))

        // next point is at the top right corner
        arcPath.addCurve(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height + self.bounds.height * 0.25),
                         controlPoint1: CGPoint(x: self.bounds.width - 10, y: self.bounds.height),
                         controlPoint2: CGPoint(x: self.bounds.width - 10, y: self.bounds.height + self.bounds.height * 0.25))

        // create a line segment arc from top right corner to bottom center
//        arcPath.addLine(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height))

        // create a line segment from bottom center to top left corner
//        arcPath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        
        arcPath.addCurve(to: CGPoint(x: 0.0 - 3, y: self.bounds.height),
         controlPoint1: CGPoint(x: 0.0 + 10, y: self.bounds.height + self.bounds.height * 0.25),
         controlPoint2: CGPoint(x: 0.0 + 10, y: self.bounds.height))
        
        shapeLayer.path = arcPath.cgPath
    }
}
