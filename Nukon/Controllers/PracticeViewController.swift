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

enum SelectedType {
    case hiragana
    case katakana
}

class PracticeViewController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate {
    
    @IBOutlet weak var topSwerve: UIView!
    @IBOutlet weak var bottomSwerve: GradientView!
    
    @IBOutlet weak var hiraganaCharacter: GradientView!
    
    @IBOutlet weak var katakanaCharacter: GradientView!
    
//    @IBOutlet var katakanaButton: UITapGestureRecognizer!
//    @IBOutlet var hiraganaButton: UITapGestureRecognizer!
    
    @IBOutlet weak var baseViewForInteractableElements: UIView!
    @IBOutlet weak var origamiKraneImage: CustomImageView!
    var recongnizer = UIPanGestureRecognizer()
    
    var japaneseType: JapaneseType?
    var sound: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        origamiKraneImage.addGestureRecognizer(recongnizer)

        let topSwerveMask = UIImageView(image: #imageLiteral(resourceName: "topSwerve3"))
        topSwerve.mask = topSwerveMask
        
        let bottomSwerveMask = UIImageView(image: #imageLiteral(resourceName: "bottomSwerve2"))
        bottomSwerve.mask = bottomSwerveMask
        
        let hiraganaCharacterMask = UIImageView(image: #imageLiteral(resourceName: "hiraganaChar"))
        hiraganaCharacter.mask = hiraganaCharacterMask
        
        let katakanaCharacterMask = UIImageView(image: #imageLiteral(resourceName: "katakanaChar"))
        katakanaCharacter.mask = katakanaCharacterMask
        
        
        view.addInteraction(UIDragInteraction(delegate: self))
        origamiKraneImage.isUserInteractionEnabled = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let japaneseType = self.japaneseType else {return}
        switch japaneseType {
        case .hiragana, .voicedHiragana, .yVowelHiragana:
            self.tappedHiraganaButton(self.hiraganaCharacter)
        case .katakana, .voicedKatakana, .yVowelKatakana:
            self.tappedKatakanaButton(self.katakanaCharacter)
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
        self.navigationController?.pushViewController(newLevelVC, animated: true)
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
    
    
    @IBAction func kranePan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    

    
    @IBAction func unwindToPracticeViewController(_ segue: UIStoryboardSegue) {
    }
}



extension PracticeViewController {
    
    
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        

        let touchPoint = session.location(in: self.view)
        if let touchedKrane = self.view.hitTest(touchPoint, with: nil) as? CustomImageView {
            
            let touchedImage = touchedKrane.image
            
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            
            return [dragItem]
        }
        
        return []
    }
    
    
    
    
    
    
}






















