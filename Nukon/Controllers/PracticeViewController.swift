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

class PracticeViewController: UIViewController {

    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var haraganaButton: UIButton!
    @IBOutlet weak var katakanaButton: UIButton!
    
    var japaneseType: JapaneseType?
    var sound: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let japaneseType = self.japaneseType else {return}
        switch japaneseType {
        case .hiragana, .voicedHiragana:
            self.hiraganaButtonTapped(self.haraganaButton)
        case .katakana, .voicedKatakana:
            self.katakanaButtonTapped(self.katakanaButton)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        printLabel.text = "hiragana tapped"
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
        printLabel.text = "katakana tapped"
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
