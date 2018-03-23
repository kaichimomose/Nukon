//
//  Exit.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/17/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import Speech

class Exit: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var effects: SoundEffects?
    
    var dismissedView: UIVisualEffectView!
    
    var appointedView: UIVisualEffectView?
    
    var blur: UIVisualEffect!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                self.dismissSuperview(self.dismissedView)
            }, completion: { (_) in
                
//                if let view = self.appointedView {
//                    self.appointSuperview(view)
//
//                }
                
                SFSpeechRecognizer.requestAuthorization({ (authStatus) in
                    print(authStatus)
                })
                
            })
        }
    }
    
    func dismissSuperview(_ view: UIVisualEffectView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            view.effect = nil
            view.alpha = 0
        }) { (_) in
            view.removeFromSuperview()
        }
    }
    
    func appointSuperview(_ view: UIVisualEffectView) {
        
        view.center = view.superview!.center
        view.frame = view.superview!.frame
        
        view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.effects?.swooshResource(.water)
            view.effect = self.blur
            view.isHidden = false
            view.transform = CGAffineTransform.identity
        }, completion: nil)

    }
    
}
