//
//  SunButton.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/1/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class SunButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = layer.frame.height / 2
        layer.backgroundColor = UIColor.redSun.cgColor
    }

}
