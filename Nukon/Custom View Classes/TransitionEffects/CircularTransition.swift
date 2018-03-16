//
//  CircularTransition.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/12/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class CircularTransition: NSObject {
    
    var circle = UIView()
    
    var startingPoint = CGPoint.zero
    
    var circleColor = UIColor()
    
    var duration = 0.1
    
    var presenting = true
    
    
}




extension CircularTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if presenting {
            if let presentedView = transitionContext.view(forKey: .to) {
//                let fromView = transitionContext.view(forKey: .from)
                
                let viewCenter = presentedView.center
                
                let viewSize = presentedView.frame.size

                
                circle = UIView()
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)

                circle.layer.cornerRadius = circle.frame.size.width / 2
                circle.center = startingPoint

                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                presentedView.alpha = 0
                
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration + 0.2, animations: {
                    self.circle.transform = CGAffineTransform.identity
//                    presentedView.center = viewCenter
                }, completion: { (success: Bool) in
                    UIView.animate(withDuration: self.duration + 0.2, animations: {
                        self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        presentedView.alpha = 1
                    })
                    
                    presentedView.transform = CGAffineTransform.identity
                    transitionContext.completeTransition(success)
                })
            }
            
            
        } else {
            let transitionModeKey = UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.width / 2
                
//                circle.center = startingPoint
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                }, completion: { (success: Bool) in
                    returningView.center = viewCenter
                    
                    returningView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
    
    
    func frameForCircle(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect (origin: CGPoint.zero, size: size)
    }
    
}























