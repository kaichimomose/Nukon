//
//  SimpleTransition.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/13/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class SimpleTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    
    var presenting = true
    
    var originFrame = CGRect.zero
    
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        
        toView.alpha = 0.0
        
        
        UIView.animate(withDuration: duration, animations: {
            toView.alpha = 1
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    
    
}
