//
//  MenuButton.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/2/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class studyButton: UIButton {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        layer.contents = UIImage(named: "study")?.cgImage
        layer.contentsGravity = kCAGravityCenter
        
        layer.backgroundColor = UIColor.lavender.cgColor
        layer.cornerRadius = layer.frame.height / 2
    }
 

}


class combosButtons: UIButton {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        layer.contents = UIImage(named: "combos")?.cgImage
        layer.contentsGravity = kCAGravityCenter
    
        layer.backgroundColor = UIColor.peach.cgColor
        layer.cornerRadius = layer.frame.height / 2
    }
    
    
}

class characterListButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.aqua.setFill()
        path.fill()
    }
    
    
}
