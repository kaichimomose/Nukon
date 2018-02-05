//
//  NewLevelViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 12/5/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class NewLevelViewController: UIViewController {

//    @IBOutlet weak var foundationStage: UIImageView!
    @IBOutlet weak var beginnerLevelTrackerView: UIView!
    @IBOutlet weak var intermediateLevelTrackerView: UIView!
    @IBOutlet weak var advancedLevelTrackerView: UIView!
    
    
    //OBJECTS USED FOR THE BLUR OVERLAP
    @IBOutlet var levelCounterForOverlap: LevelCounterView!
    @IBOutlet var levelCounterPopUp: UIView!
    
    @IBOutlet var toriTwoOverlapOfBlur: UIImageView!
    @IBOutlet var foundationStagePopUp: UIView!
    
    @IBOutlet var diamondOverlapOverBlur: UIImageView!
    @IBOutlet var BonusStagePopUp: UIView!
    
    @IBOutlet var pagodaOverlapOverBlur: UIImageView!
    @IBOutlet var intermediateStagePopUp: UIView!
    
    @IBOutlet weak var visualEffectOne: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    
    var japaneseType: JapaneseType?
    var selectedType: SelectedType?
    var sound: String?
    var wordsLearnt = [WordLearnt]()
    var numberOfRegular: Int = 0 //wordlearnt instances whose japanese type is hiragana or katakana
    var numberOfVoiced: Int = 0 //wordlearnt instances whose japanese type is voiced-hiragana or voiced-katakana
    var numberOfYVowel: Int = 0 //wordlearnt instances whose japanese type is y-vowel-hiragana or y-vowel-katakana
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedType = self.selectedType else {return}
        self.title = selectedType.rawValue
        switch selectedType {
        case .hiragana:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 203/255, blue: 201/255, alpha: 1)
        case .katakana:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 98/255, green: 155/255, blue: 196/255, alpha: 1)
        }
        
        wordsLearnt = CoreDataHelper.retrieveWordLearnt()
        categorizingWordsLearnt()
        
        LevelTrackerViewSetUp()
        
        effect = visualEffectOne.effect
        visualEffectOne.effect = nil
        self.view.sendSubview(toBack: visualEffectOne)
        
        levelCounterPopUp.layer.cornerRadius = 10
        foundationStagePopUp.layer.cornerRadius = 10
        BonusStagePopUp.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let japaneseType = self.japaneseType else {return}
        switch japaneseType {
        case .hiragana, .katakana:
            self.toriPressed(self.toriPress)
        case .voicedHiragana, .voicedKatakana:
            self.pagodaPressed(self.pagodaPress)
        case .yVowelHiragana, .yVowelKatakana:
            self.diamondPressed(self.diamondPress)
        }
    }

    func categorizingWordsLearnt() {
        for wordLearnt in self.wordsLearnt {
            if wordLearnt.numberOfCorrect >= 5 {
                //distinguishs japanese type
                var japaneseType: JapaneseType!
                if wordLearnt.type == JapaneseType.hiragana.rawValue {
                    japaneseType = .hiragana
                }
                else if wordLearnt.type == JapaneseType.katakana.rawValue {
                    japaneseType = .katakana
                }
                else if wordLearnt.type == JapaneseType.voicedHiragana.rawValue {
                    japaneseType = .voicedHiragana
                }
                else if wordLearnt.type == JapaneseType.voicedKatakana.rawValue {
                    japaneseType = .voicedKatakana
                }
                else if wordLearnt.type == JapaneseType.yVowelHiragana.rawValue {
                    japaneseType = .yVowelHiragana
                }
                else if wordLearnt.type == JapaneseType.yVowelKatakana.rawValue {
                    japaneseType = .yVowelKatakana
                }
                //categorizes wordLearnt object among 3 types based on japaneseType
                guard let selectedType = self.selectedType else {return}
                switch selectedType {
                case .hiragana:
                    switch japaneseType {
                    case .hiragana:
                        numberOfRegular += 1
                    case .voicedHiragana:
                        numberOfVoiced += 1
                    case .yVowelHiragana:
                        numberOfYVowel += 1
                    default:
                        numberOfRegular += 0
                    }
                case .katakana:
                    switch japaneseType {
                    case .katakana:
                        numberOfRegular += 1
                    case .voicedKatakana:
                        numberOfVoiced += 1
                    case .yVowelKatakana:
                        numberOfYVowel += 1
                    default:
                        numberOfRegular += 0
                    }
                }
            }
        }
    }
    
    func LevelTrackerViewSetUp() {
        beginnerLevelTrackerView.backgroundColor = .clear
        intermediateLevelTrackerView.backgroundColor = .clear
        advancedLevelTrackerView.backgroundColor = .clear
        
        beginnerLevelCounterView.numberOfLevels = 46
        beginnerLevelCounterView.counter = numberOfRegular
        intermediateLevelCounterView.numberOfLevels = 25
        intermediateLevelCounterView.counter = numberOfVoiced
        advancedLevelCounterView.numberOfLevels = 21
        advancedLevelCounterView.counter = numberOfYVowel
    }
   
    @IBAction func dismissIntermediatePopUp(_ sender: Any) {
        animateOutIntermediateStageInfo()
    }
    
    @IBAction func dismissFoundationPopUp(_ sender: Any) {
        animateOutFoundationStageInfo()
    }
    
    @IBAction func dismissBonusStagePopUp(_ sender: Any) {
        animateOutBonusStageInfo()
    }
    
    @IBOutlet var toriPress: UITapGestureRecognizer!
    @IBOutlet var diamondPress: UITapGestureRecognizer!
    @IBOutlet var pagodaPress: UITapGestureRecognizer!
    
    @IBOutlet weak var beginnerLevelCounterView: LevelCounterView!
    @IBOutlet weak var intermediateLevelCounterView: LevelCounterView!
    @IBOutlet weak var advancedLevelCounterView: LevelCounterView!
    
    @IBAction func toriPressed(_ sender: UITapGestureRecognizer) {
        let japaneseCharactersTVC = storyboard?.instantiateViewController(withIdentifier: "JapaneseCharactersTVC") as! JapaneseCharactersTableViewController
        if let japaneseType = self.japaneseType {
            japaneseCharactersTVC.selectedType = japaneseType
        } else {
            if let selectedType = self.selectedType {
                switch selectedType {
                case .hiragana:
                    japaneseCharactersTVC.selectedType = .hiragana
                case .katakana:
                    japaneseCharactersTVC.selectedType = .katakana
                }
            }
        }
        if let sound = self.sound {
            japaneseCharactersTVC.preSelectedSound = sound
        }
        self.navigationController?.pushViewController(japaneseCharactersTVC, animated: true)
//        show(japaneseCharactersTVC, sender: (Any).self)
    }
    
    @IBAction func pagodaPressed(_ sender: UITapGestureRecognizer) {
        let japaneseCharactersTVC = storyboard?.instantiateViewController(withIdentifier: "JapaneseCharactersTVC") as! JapaneseCharactersTableViewController
        if let japaneseType = self.japaneseType {
            japaneseCharactersTVC.selectedType = japaneseType
        } else {
            if let selectedType = self.selectedType {
                switch selectedType {
                case .hiragana:
                    japaneseCharactersTVC.selectedType = .voicedHiragana
                case .katakana:
                    japaneseCharactersTVC.selectedType = .voicedKatakana
                }
            }
        }
        if let sound = self.sound {
            japaneseCharactersTVC.preSelectedSound = sound
        }
        self.navigationController?.pushViewController(japaneseCharactersTVC, animated: true)
    }
    
    @IBAction func diamondPressed(_ sender: UITapGestureRecognizer) {
        let japaneseCharactersTVC = storyboard?.instantiateViewController(withIdentifier: "JapaneseCharactersTVC") as! JapaneseCharactersTableViewController
        if let japaneseType = self.japaneseType {
            japaneseCharactersTVC.selectedType = japaneseType
        } else {
            if let selectedType = self.selectedType {
                switch selectedType {
                case .hiragana:
                    japaneseCharactersTVC.selectedType = .yVowelHiragana
                case .katakana:
                    japaneseCharactersTVC.selectedType = .yVowelKatakana
                }
            }
        }
        if let sound = self.sound {
            japaneseCharactersTVC.preSelectedSound = sound
        }
        self.navigationController?.pushViewController(japaneseCharactersTVC, animated: true)
    }
    
    
    
}





extension NewLevelViewController {
    
    
    //LEVEL TRACKER ANIMATIONS ----------------------------------------//
    func animateInLeveltrackerInfo() {
        self.view.bringSubview(toFront: visualEffectOne)
        
        self.view.addSubview(levelCounterPopUp)
        self.view.addSubview(levelCounterForOverlap)
        
        levelCounterForOverlap.center.x = self.view.center.x
        levelCounterForOverlap.center.y = self.view.center.y * 0.75
        
        levelCounterPopUp.center.x = self.view.center.x
        levelCounterPopUp.center.y = self.view.center.y * 1.25
        
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
        self.view.bringSubview(toFront: visualEffectOne)
        
        self.view.addSubview(foundationStagePopUp)
        self.view.addSubview(toriTwoOverlapOfBlur)
        
        self.toriTwoOverlapOfBlur.center.x = self.view.center.x
        self.toriTwoOverlapOfBlur.center.y = self.view.center.y * 0.75
        
        self.foundationStagePopUp.center.x = self.view.center.x
        self.foundationStagePopUp.center.y = self.view.center.y * 1.25
        
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
            
            self.animateInIntermediateStageInfo()
        }
    }
    
    //Intermediate STAGE ANIMATIONS ------------------------------------------//
    func animateInIntermediateStageInfo() {
        //WILL UNCOMMENT THIS WHEN I SEPARATE CONCERNS FOR EACH BUTTON
        self.view.bringSubview(toFront: visualEffectOne)
        
        self.view.addSubview(intermediateStagePopUp)
        self.view.addSubview(pagodaOverlapOverBlur)
        
        self.pagodaOverlapOverBlur.center.x = self.view.center.x
        self.pagodaOverlapOverBlur.center.y = self.view.center.y * 0.75
        
        self.intermediateStagePopUp.center.x = self.view.center.x
        self.intermediateStagePopUp.center.y = self.view.center.y * 1.25
        
        intermediateStagePopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        intermediateStagePopUp.alpha = 0
        
        pagodaOverlapOverBlur.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        pagodaOverlapOverBlur.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectOne.effect = self.effect
            
            self.intermediateStagePopUp.alpha = 0.95
            self.intermediateStagePopUp.transform = CGAffineTransform.identity
            
            self.pagodaOverlapOverBlur.transform = CGAffineTransform.identity
            self.pagodaOverlapOverBlur.alpha = 1
        }
        
        
    }
    
    
    func animateOutIntermediateStageInfo() {
        UIView.animate(withDuration: 0.3, animations: {
            self.intermediateStagePopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.intermediateStagePopUp.alpha = 0
            
            self.pagodaOverlapOverBlur.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            self.pagodaOverlapOverBlur.alpha = 0
            
            self.visualEffectOne.effect = nil
        }) { (success: Bool) in
            //            self.view.sendSubview(toBack: self.visualEffectOne)
            
            self.intermediateStagePopUp.removeFromSuperview()
            self.pagodaOverlapOverBlur.removeFromSuperview()
            
            self.animateInBonusStageInfo()
        }
    }
    
    //BONUS STAGE ANIMATIONS---------------------------------------------///
    func animateInBonusStageInfo() {
        
        self.view.addSubview(BonusStagePopUp)
        self.view.addSubview(diamondOverlapOverBlur)
        
        self.diamondOverlapOverBlur.center.x = self.view.center.x
        self.diamondOverlapOverBlur.center.y = self.view.center.y * 0.75
        
        self.BonusStagePopUp.center.x = self.view.center.x
        self.BonusStagePopUp.center.y = self.view.center.y * 1.25
        
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
