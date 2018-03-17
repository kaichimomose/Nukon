//
//  Exit.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/17/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class Exit: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var dismissedView: UIVisualEffectView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { (_) in
            self.dismissSuperView(self.dismissedView)
        }
        
        
    }
    
    func dismissSuperView(_ view: UIVisualEffectView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            view.effect = nil
        }) { (_) in
            view.isHidden = true
        }

    }
}
