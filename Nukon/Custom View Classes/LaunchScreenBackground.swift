//
//  LaunchScreenBackground.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/22/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class LaunchScreenBackground: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.backgroundColor = UIColor.rgb(r: 175, g: 203, b: 255).cgColor
        layer.cornerRadius = layer.frame.height / 2
    }

}
