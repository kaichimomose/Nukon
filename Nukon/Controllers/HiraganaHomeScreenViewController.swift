//
//  HiraganaHomeScreenViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 2/27/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

@IBDesignable class HiraganaHomeScreenViewController: UIViewController {
    
    @IBOutlet weak var homeSunButton: UIButton!
    
    var pulsatingLayer: CAShapeLayer!
    
    var popCount = 0
    
    @IBOutlet weak var studyButton: studyButton!
    
    @IBOutlet weak var comboButton: combosButtons!
    
    @IBOutlet weak var characterButton: characterListButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Bring Home Sun Button to the front
        view.bringSubview(toFront: homeSunButton)
        
        //Commence shadow animations
        homeSunButton.animateShadow()
        
        
        //Create pulsating layer on View Controller's View
        createPulseLayer()
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    //MAIN BUTTON'S ACTION WHEN PRESSED
    @IBAction func sunPressed(_ sender: Any) {
        
        //When sun button is pressed, animate the pulsating layer
        if popCount == 0 {
            homeSunButton.stopAnimating()
            animatePulsatingLayer()
            popOutMenuButtons()
            popCount += 1
        } else {
            animatePulsatingLayer()
            popInMenuButtons()
            popCount -= 1
        }
        
    }
    
    
    @IBAction func studyButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func comboButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CharactersSelection", bundle: .main)
        let japaneseCharactersCVC = storyboard.instantiateViewController(withIdentifier: "CharactersSelection") as! JapaneseCharactersCollectionViewController
        japaneseCharactersCVC.japaneseType = .yVowelHiragana
        self.present(japaneseCharactersCVC, animated: true)
    }
    
    @IBAction func charButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CharactersSelection", bundle: .main)
        let japaneseCharactersCVC = storyboard.instantiateViewController(withIdentifier: "CharactersSelection") as! JapaneseCharactersCollectionViewController
        japaneseCharactersCVC.japaneseType = .hiragana
        self.present(japaneseCharactersCVC, animated: true)
    }
    
    

}

extension HiraganaHomeScreenViewController {
    
    //Animations
    private func createPulseLayer() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 0.1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = UIColor.white.cgColor
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
    }
    
   //Pulsating animations
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        
        //initial values
        animation.toValue = 950
        fadeAnimation.fromValue = 1
        
        //how long animation runs
        animation.duration = 0.4
        fadeAnimation.duration = 0.45
        
        //ending values of animations
        fadeAnimation.toValue = 0
        
        //animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsating")
        pulsatingLayer.add(fadeAnimation, forKey: "fade")
    }
    
    
    //Menu Button Animations -----------------------------------------------------
    func popOutMenuButtons() {
        UIView.animate(withDuration: 0.2, delay: 0.125, options: .curveEaseInOut, animations: {
            self.studyButton.center.x = self.studyButton.center.x - 155
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.comboButton.center.y = self.comboButton.center.y - 155
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.characterButton.center.x = self.characterButton.center.x + 155
                }, completion: nil)
            })
        }
    }
    
    func popInMenuButtons() {
        UIView.animate(withDuration: 0.2, delay: 0.125, options: .curveEaseInOut, animations: {
            self.studyButton.center.x = self.studyButton.center.x + 155
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.comboButton.center.y = self.comboButton.center.y + 155
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.characterButton.center.x = self.characterButton.center.x - 155
                }, completion: nil)
            })
        }
    }
}

