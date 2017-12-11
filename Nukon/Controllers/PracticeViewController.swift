//
//  PracticeViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

protocol JapaneseDelegate: class {
    func sendJapanese(selectedJapanese: [String])
}

enum SelectedType: String {
    case hiragana = "Hiragana"
    case katakana = "Katakana"
}

class PracticeViewController: UIViewController {
    
    @IBOutlet weak var hiraganaTab: UIButton!
    @IBOutlet weak var katakanaTab: tabGradientButton!
    @IBOutlet weak var kanjiTab: tabGradientButton!
    
    
    
    //------------------------------------------------------- 
    @IBOutlet weak var hiraganaTabView: GradientView!
    @IBOutlet weak var katakanaTabView: GradientView!
    @IBOutlet weak var kanjiTabView: GradientView!
    
    
    
    //-------------------------------------------------------
    @IBOutlet var hiraganaPopUpView: UIView!
    @IBOutlet var katakanaPopUpView: UIView!
    @IBOutlet var kanjiPopUpView: UIView!

    
    @IBOutlet weak var backgroundBlurView: UIView!
    
    @IBOutlet weak var hiraganaButton: CustomButton!
    @IBOutlet weak var katakanaButton: CustomButton!
    
    @IBOutlet weak var hiraganaTabViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var katakanaTabViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var kanjiTabViewLeadingConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var kanjiTextView: UITextView!
    @IBOutlet weak var katakanaTextView: UITextView!
    
    @IBOutlet weak var hiraganaTextView: UITextView!
    
    var japaneseType: JapaneseType?
    var sound: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabMask = UIImageView(image: #imageLiteral(resourceName: "tabShape"))
        hiraganaTabView.mask = tabMask
        
        let katakanaTabMask = UIImageView(image: #imageLiteral(resourceName: "tabShape"))
        katakanaTabView.mask = katakanaTabMask
        
        let kanjiTabMask = UIImageView(image: #imageLiteral(resourceName: "tabShape"))
        kanjiTabView.mask = kanjiTabMask
        
        
        kanjiTextView.isEditable = false
        katakanaTextView.isEditable = false
        hiraganaTextView.isEditable = false
        
        kanjiTextView.isScrollEnabled = true
        katakanaTextView.isScrollEnabled = false
        hiraganaTextView.isScrollEnabled = false
        
        
//        hiraganaTabView.center.x -= (view.bounds.width)
//        katakanaTabView.center.x -= (view.bounds.width)
//        kanjiTabView.center.x -= (view.bounds.width)
        
        
        hiraganaPopUpView.layer.cornerRadius = 20
        katakanaPopUpView.layer.cornerRadius = 20
        kanjiPopUpView.layer.cornerRadius = 20
        
        //ser navigation bar color and text color
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        hiraganaTabView.center.x -= (view.bounds.width)
//        katakanaTabView.center.x -= (view.bounds.width)
//        kanjiTabView.center.x -= (view.bounds.width)
        
        hiraganaTabViewLeadingConstraints.constant = -122
        katakanaTabViewLeadingConstraints.constant = -122
        kanjiTabViewLeadingConstraints.constant = -122
        
        
        guard let japaneseType = self.japaneseType else {return}
        switch japaneseType {
        case .hiragana, .voicedHiragana, .yVowelHiragana:
            self.tappedHiraganaButton(self.hiraganaButton)
        case .katakana, .voicedKatakana, .yVowelKatakana:
            self.tappedKatakanaButton(self.katakanaButton)
        }
    }
    

    @IBAction func tappedHiraganaButton(_ sender: Any) {
        let newLevelVC = storyboard?.instantiateViewController(withIdentifier: "NewLevelVC") as! NewLevelViewController
        if let japaneseType = self.japaneseType {
            newLevelVC.japaneseType = japaneseType
        } else {
            newLevelVC.selectedType = SelectedType.hiragana
        }
        if let sound = self.sound {
            newLevelVC.sound = sound
        }
        animateOutHiraganaPopUp()
        self.navigationController?.pushViewController(newLevelVC, animated: true)
    }
    
    
    @IBAction func tappedKatakanaButton(_ sender: Any) {
        let newLevelVC = storyboard?.instantiateViewController(withIdentifier: "NewLevelVC") as! NewLevelViewController
        if let japaneseType = self.japaneseType {
            newLevelVC.japaneseType = japaneseType
        } else {
            newLevelVC.selectedType = SelectedType.katakana
        }
        if let sound = self.sound {
            newLevelVC.sound = sound
        }
        animateOutKatakanaPopUp()
        self.navigationController?.pushViewController(newLevelVC, animated: true)
    }
    
    @IBAction func tappedKanjiButton(_ sender: Any) {
        animateOutKanjiPopUp()
        animateOutTab(tabViewConstraints: kanjiTabViewLeadingConstraints)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let japaneseCharactersTVC = segue.destination as! JapaneseCharactersTableViewController
//        if segue.identifier == "hiragana"{
//            japaneseCharactersTVC.selectedType = JapaneseType.hiragana
//        }
//        else if segue.identifier == "katakana" {
//            japaneseCharactersTVC.selectedType = JapaneseType.katakana
//        }
//    }
    
    
    @IBAction func hiraganaTabPulled(_ sender: Any) {
        animateOutKanjiPopUp()
        animateOutKatakanaPopUp()
        animateInHiraganaPopUp()
        animateInTab(tabViewConstraints: hiraganaTabViewLeadingConstraints)
        animateOutTab(tabViewConstraints: katakanaTabViewLeadingConstraints)
        animateOutTab(tabViewConstraints: kanjiTabViewLeadingConstraints)
    }
    
    @IBAction func katakanaTabPulled(_ sender: Any) {
        animateOutKanjiPopUp()
        animateOutHiraganaPopUp()
        animateInKatakanaPopUp()
        animateInTab(tabViewConstraints: katakanaTabViewLeadingConstraints)
        animateOutTab(tabViewConstraints: hiraganaTabViewLeadingConstraints)
        animateOutTab(tabViewConstraints: kanjiTabViewLeadingConstraints)
    }
    
    
    @IBAction func kanjiTabPulled(_ sender: Any) {
        animateOutHiraganaPopUp()
        animateOutKatakanaPopUp()
        animateInKanjiPopUp()
        animateInTab(tabViewConstraints: kanjiTabViewLeadingConstraints)
        animateOutTab(tabViewConstraints: hiraganaTabViewLeadingConstraints)
        animateOutTab(tabViewConstraints: katakanaTabViewLeadingConstraints)
    }
    

    
    @IBAction func unwindToPracticeViewController(_ segue: UIStoryboardSegue) {
        self.navigationController?.navigationBar.barTintColor = .white
    }
}



extension PracticeViewController {
    //ANIMATIONS FOR DESCRIPTION POP UPS-------
    
    
    
    //HIRAGANA POP UP ANIMATION------
    func animateInHiraganaPopUp() {
        
        self.backgroundBlurView.addSubview(hiraganaPopUpView)
        
        
        hiraganaPopUpView.center.x = self.backgroundBlurView.center.x
        hiraganaPopUpView.center.y = self.backgroundBlurView.center.y * 1.575
        
        hiraganaPopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        hiraganaPopUpView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.7) {
            
            self.hiraganaPopUpView.alpha = 1
            self.hiraganaPopUpView.transform = CGAffineTransform.identity
            
        }
    }
    
    
    func animateOutHiraganaPopUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.hiraganaPopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.hiraganaPopUpView.alpha = 0
            
        }) { (success: Bool) in
            self.hiraganaPopUpView.removeFromSuperview()
        }
    }
    
    
    
    //KATAKANA POP UP ANIMATION------
    func animateInKatakanaPopUp() {
        
        self.backgroundBlurView.addSubview(katakanaPopUpView)
        
        
        katakanaPopUpView.center.x = self.backgroundBlurView.center.x
        katakanaPopUpView.center.y = self.backgroundBlurView.center.y * 1.575
        
        katakanaPopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        katakanaPopUpView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.7) {
            
            self.katakanaPopUpView.alpha = 1
            self.katakanaPopUpView.transform = CGAffineTransform.identity
            
        }
    }
    
    func animateOutKatakanaPopUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.katakanaPopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.katakanaPopUpView.alpha = 0
            
        }) { (success: Bool) in
            self.katakanaPopUpView.removeFromSuperview()
        }
    }
    
    
    
    //KANJI POP UP ANIMATION------
    func animateInKanjiPopUp() {
        
        self.backgroundBlurView.addSubview(kanjiPopUpView)
        
        
        kanjiPopUpView.center.x = self.backgroundBlurView.center.x
        kanjiPopUpView.center.y = self.backgroundBlurView.center.y * 1.575
        
        kanjiPopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        kanjiPopUpView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.7) {
            
            self.kanjiPopUpView.alpha = 1
            self.kanjiPopUpView.transform = CGAffineTransform.identity
            
        }
    }
    
    
    
    func animateOutKanjiPopUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.kanjiPopUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.kanjiPopUpView.alpha = 0
            
        }) { (success: Bool) in
            self.kanjiPopUpView.removeFromSuperview()
        }
    }
    
}


extension PracticeViewController {
    //ANIMATIONS FOR EACH TAB VIEW
    
    func animateInTab(tabViewConstraints: NSLayoutConstraint) {
//        tabViewConstraints.constant += 61
        UIView.animate(withDuration: 0.3) {
            if tabViewConstraints.constant == -122 {
                tabViewConstraints.constant += 61
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func animateOutTab(tabViewConstraints: NSLayoutConstraint) {
//        tabViewConstraints.constant -= 61
        UIView.animate(withDuration: 0.5) {
            if tabViewConstraints.constant == -61 {
                tabViewConstraints.constant -= 61
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    
}

























