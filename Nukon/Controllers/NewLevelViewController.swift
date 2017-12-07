//
//  NewLevelViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 12/5/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class NewLevelViewController: UIViewController {

    @IBOutlet weak var foundationStage: UIImageView!
    @IBOutlet weak var levelTrackerView: UIView!
    
    
    //OBJECTS USED FOR THE BLUR OVERLAP
    @IBOutlet var levelCounterForOverlap: LevelCounterView!
    @IBOutlet var levelCounterPopUp: UIView!
    
    @IBOutlet var toriTwoOverlapOfBlur: UIImageView!
    @IBOutlet var foundationStagePopUp: UIView!
    
    @IBOutlet var diamondOverlapOverBlur: UIImageView!
    @IBOutlet var BonusStagePopUp: UIView!
    
    
    
    @IBOutlet weak var visualEffectOne: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    
    func levelTrackerViewSetUp() {
        levelTrackerView.backgroundColor = .clear
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        levelTrackerViewSetUp()
        
        effect = visualEffectOne.effect
        visualEffectOne.effect = nil
        self.view.sendSubview(toBack: visualEffectOne)
        
        levelCounterPopUp.layer.cornerRadius = 10
        foundationStagePopUp.layer.cornerRadius = 10
        BonusStagePopUp.layer.cornerRadius = 10
        
        
    }
    

    
   
    @IBAction func dismissFoundationPopUp(_ sender: Any) {
        animateOutFoundationStageInfo()
    }
    
    
    @IBAction func dismissBonusStagePopUp(_ sender: Any) {
        animateOutBonusStageInfo()
    }
    
    
}





extension NewLevelViewController {
    
    
    //LEVEL TRACKER ANIMATIONS ----------------------------------------//
    func animateInLeveltrackerInfo() {
        self.view.bringSubview(toFront: visualEffectOne)
        
        
        self.view.addSubview(levelCounterPopUp)
        self.view.addSubview(levelCounterForOverlap)
        
        
        levelCounterPopUp.center = self.view.center
        levelCounterForOverlap.center.x = self.view.center.x
        levelCounterForOverlap.center.y = self.view.center.y - 270
        
        levelCounterPopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        levelCounterPopUp.alpha = 0
        
        levelCounterForOverlap.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        levelCounterForOverlap.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectOne.effect = self.effect
            
            self.levelCounterPopUp.alpha = 1
            self.levelCounterPopUp.transform = CGAffineTransform.identity
            
            self.levelCounterForOverlap.transform = CGAffineTransform.identity
            self.levelCounterForOverlap.alpha = 1
        }
    }
    
    
    func animateOutLevelTrackerInfo() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.levelCounterPopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.levelCounterPopUp.alpha = 0
            
            self.levelCounterForOverlap.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.levelCounterForOverlap.alpha = 0
            
            self.visualEffectOne.effect = nil
        }) { (success: Bool) in
//            self.view.sendSubview(toBack: self.visualEffectOne)
            
            self.levelCounterPopUp.removeFromSuperview()
            self.levelCounterForOverlap.removeFromSuperview()
            self.animateInFoundationStageInfo()
        }
    }
    
    @IBAction func initiate(_ sender: Any) {
        
        animateInLeveltrackerInfo()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        animateOutLevelTrackerInfo()
    }
    
    
    
    //FOUNDATION STAGE ANIMATIONS ------------------------------------------//
    func animateInFoundationStageInfo() {
        //WILL UNCOMMENT THIS WHEN I SEPARATE CONCERNS FOR EACH BUTTON
//        self.view.bringSubview(toFront: visualEffectOne)
        
        self.view.addSubview(foundationStagePopUp)
        self.view.addSubview(toriTwoOverlapOfBlur)
        
        self.foundationStagePopUp.center.x = self.view.center.x + 95
        self.foundationStagePopUp.center.y = self.view.center.y
        
        self.toriTwoOverlapOfBlur.center.x = self.view.center.x - 140
        self.toriTwoOverlapOfBlur.center.y = self.view.center.y - 25
        
        foundationStagePopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        foundationStagePopUp.alpha = 0
        
        toriTwoOverlapOfBlur.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        toriTwoOverlapOfBlur.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectOne.effect = self.effect
            
            self.foundationStagePopUp.alpha = 0.95
            self.foundationStagePopUp.transform = CGAffineTransform.identity
            
            self.toriTwoOverlapOfBlur.transform = CGAffineTransform.identity
            self.toriTwoOverlapOfBlur.alpha = 1
        }
        
        
    }
    
    
    func animateOutFoundationStageInfo() {
        UIView.animate(withDuration: 0.3, animations: {
            self.foundationStagePopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.foundationStagePopUp.alpha = 0
            
            self.toriTwoOverlapOfBlur.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.toriTwoOverlapOfBlur.alpha = 0
            
            self.visualEffectOne.effect = nil
        }) { (success: Bool) in
//            self.view.sendSubview(toBack: self.visualEffectOne)
            
            self.foundationStagePopUp.removeFromSuperview()
            self.toriTwoOverlapOfBlur.removeFromSuperview()
            
            self.animateInBonusStageInfo()
        }
    }
    
    //BONUS STAGE ANIMATIONS---------------------------------------------///
    func animateInBonusStageInfo() {
        
        self.view.addSubview(BonusStagePopUp)
        self.view.addSubview(diamondOverlapOverBlur)
        
        self.BonusStagePopUp.center.x = self.view.center.x - 95
        self.BonusStagePopUp.center.y = self.view.center.y - 10
        
        self.diamondOverlapOverBlur.center.x = self.view.center.x + 125
        self.diamondOverlapOverBlur.center.y = self.view.center.y - 25
        
        BonusStagePopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        BonusStagePopUp.alpha = 0
        
        diamondOverlapOverBlur.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        diamondOverlapOverBlur.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectOne.effect = self.effect
            
            self.BonusStagePopUp.alpha = 0.95
            self.BonusStagePopUp.transform = CGAffineTransform.identity
            
            self.diamondOverlapOverBlur.transform = CGAffineTransform.identity
            self.diamondOverlapOverBlur.alpha = 1
        }
    }
    
    
    func animateOutBonusStageInfo() {
        UIView.animate(withDuration: 0.3, animations: {
            self.BonusStagePopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.BonusStagePopUp.alpha = 0
            
            self.diamondOverlapOverBlur.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.diamondOverlapOverBlur.alpha = 0
            
            self.visualEffectOne.effect = nil
        }) { (success: Bool) in
            self.view.sendSubview(toBack: self.visualEffectOne)
            
            self.BonusStagePopUp.removeFromSuperview()
            self.diamondOverlapOverBlur.removeFromSuperview()
            
        }
    }
    
    
    
}
