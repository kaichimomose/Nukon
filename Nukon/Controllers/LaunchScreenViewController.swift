//
//  LaunchScreenViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/22/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    
    var expansionLayer: CAShapeLayer!
    
    var sunLayer: CAShapeLayer!
    
    var effects = SoundEffects()
    
    let transition = SimpleTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        perform(#selector(LaunchScreenViewController.showApplication), with: nil, afterDelay: 3)

        // Do any additional setup after loading the view.
        createExpansionLayer()
        createSunLayer()
        sunLayer.isHidden = true
        
    }
    
    @objc func showApplication() {
        performSegue(withIdentifier: "toApp", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.2, animations: {
            self.logo.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.sunLayer.isHidden = false
                self.effects.swooshResource(.inflate)
                self.sunLayerExpansion()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.expansion()
        }
    }

    
    func createExpansionLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        expansionLayer = CAShapeLayer()
        expansionLayer.path = circularPath.cgPath
        expansionLayer.strokeColor = UIColor.clear.cgColor
        expansionLayer.lineWidth = 10
        expansionLayer.fillColor = UIColor.rgb(r: 175, g: 203, b: 255).cgColor
        expansionLayer.lineCap = kCALineCapRound
        expansionLayer.position = view.center
        view.layer.addSublayer(expansionLayer)
        view.bringSubview(toFront: logo)
    }
    
    func createSunLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        sunLayer = CAShapeLayer()
        sunLayer.path = circularPath.cgPath
        sunLayer.strokeColor = UIColor.clear.cgColor
        sunLayer.lineWidth = 10
        sunLayer.fillColor = UIColor.redSun.cgColor
        sunLayer.lineCap = kCALineCapRound
        sunLayer.position.x = view.center.x
        sunLayer.position.y = view.center.y + 25
        view.layer.addSublayer(sunLayer)
    }
    
    
    
    func expansion() {
        let expansionAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        expansionAnimation.fromValue = 1
        expansionAnimation.toValue = 950
        expansionAnimation.autoreverses = false
        
        
        expansionAnimation.duration = 1.0
        expansionAnimation.isRemovedOnCompletion = false
        expansionAnimation.fillMode = kCAFillModeForwards
        
        
        expansionLayer.add(expansionAnimation, forKey: "scale")
    }
    
    
    func sunLayerExpansion() {
        let expansionAnimation = CASpringAnimation(keyPath: "transform.scale")
        
        expansionAnimation.fromValue = 1
        expansionAnimation.toValue = 32
        
        expansionAnimation.autoreverses = false
        
        expansionAnimation.damping = 0.2
        expansionAnimation.stiffness = 85
        
//        expansionAnimation.duration = 0.5
        expansionAnimation.isRemovedOnCompletion = false
        expansionAnimation.fillMode = kCAFillModeForwards
        
        
        sunLayer.add(expansionAnimation, forKey: "scale")
    }
    

}




extension LaunchScreenViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.originFrame = self.view.frame
        return transition
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toApp" {
            let hiraganaHomeScreenVC = segue.destination as! Nukon.CustomTabBarController
            hiraganaHomeScreenVC.transitioningDelegate = self
            hiraganaHomeScreenVC.modalPresentationStyle = .custom
            present(hiraganaHomeScreenVC, animated: true, completion: nil)
        }
    }
    
    
    
}








