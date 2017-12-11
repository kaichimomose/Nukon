//
//  EditProfile.swift
//  Nukon
//
//  Created by Chris Mauldin on 12/5/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
        
        @IBInspectable var borderColor: UIColor? = UIColor.clear {
            didSet {
                layer.borderColor = self.borderColor?.cgColor
            }
        }
        
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = self.borderWidth
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
        }
        
        override func draw(_ rect: CGRect) {
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.borderWidth = self.borderWidth
            self.layer.borderColor = self.borderColor?.cgColor
        }
}
