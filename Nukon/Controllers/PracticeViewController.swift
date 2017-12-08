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

class PracticeViewController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate {
    
    @IBOutlet weak var topSwerve: UIView!
    @IBOutlet weak var bottomSwerve: GradientView!
    
    @IBOutlet weak var hiraganaCharacter: GradientView!
    
    @IBOutlet weak var katakanaCharacter: GradientView!
    
    @IBOutlet weak var baseViewForInteractableElements: UIView!
    @IBOutlet weak var origamiKraneImage: CustomImageView!
    
    
    var japaneseType: JapaneseType?
    var sound: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topSwerveMask = UIImageView(image: #imageLiteral(resourceName: "topSwerve3"))
        topSwerve.mask = topSwerveMask
        
        let bottomSwerveMask = UIImageView(image: #imageLiteral(resourceName: "bottomSwerve2"))
        bottomSwerve.mask = bottomSwerveMask
        
        let hiraganaCharacterMask = UIImageView(image: #imageLiteral(resourceName: "hiraganaChar"))
        hiraganaCharacter.mask = hiraganaCharacterMask
        
        let katakanaCharacterMask = UIImageView(image: #imageLiteral(resourceName: "katakanaChar"))
        katakanaCharacter.mask = katakanaCharacterMask
        
        
        origamiKraneImage.addInteraction(UIDragInteraction(delegate: self))
        origamiKraneImage.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let japaneseType = self.japaneseType else {return}
//        switch japaneseType {
//        case .hiragana, .voicedHiragana, .yVowelHiragana:
////            self.hiraganaButtonTapped(self.haraganaButton)
//        case .katakana, .voicedKatakana, .yVowelKatakana:
////            self.katakanaButtonTapped(self.katakanaButton)
//        }
    }
    
    
    @IBAction func hiraganaButtonTapped(_ sender: UIButton) {

        let japaneseCharactersTVC = storyboard?.instantiateViewController(withIdentifier: "JapaneseCharactersTVC") as! JapaneseCharactersTableViewController
        if let japaneseType = self.japaneseType {
            japaneseCharactersTVC.selectedType = japaneseType
        } else {
            japaneseCharactersTVC.selectedType = .hiragana
        }
        if let sound = self.sound {
            japaneseCharactersTVC.preSelectedSound = sound
        }
        self.navigationController?.pushViewController(japaneseCharactersTVC, animated: true)
    }
    
    @IBAction func katakanaButtonTapped(_ sender: UIButton) {
        let japaneseCharactersTVC = storyboard?.instantiateViewController(withIdentifier: "JapaneseCharactersTVC") as! JapaneseCharactersTableViewController
        if let japaneseType = self.japaneseType {
            japaneseCharactersTVC.selectedType = japaneseType
        } else {
            japaneseCharactersTVC.selectedType = .katakana
        }
        if let sound = self.sound {
            japaneseCharactersTVC.preSelectedSound = sound
        }
        self.navigationController?.pushViewController(japaneseCharactersTVC, animated: true)
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
    
    @IBAction func unwindToPracticeViewController(_ segue: UIStoryboardSegue) {
    }
}



extension PracticeViewController {
    
    
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        

        let touchPoint = session.location(in: self.origamiKraneImage)
        if let touchedKrane = self.origamiKraneImage.hitTest(touchPoint, with: nil) as? CustomImageView {
            
            let touchedImage = touchedKrane.image
            
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            
            return [dragItem]
        }
        
        return []
    }
    
    
    
    
    
    
}






















