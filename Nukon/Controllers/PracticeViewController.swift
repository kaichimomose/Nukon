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

class PracticeViewController: UIViewController, JapaneseDelegate {

    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var haraganaButton: UIButton!
    @IBOutlet weak var katakanaButton: UIButton!
    
    var displayJapanese = [[String]]()
    var japanese = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for words in displayJapanese {
            for word in words {
                self.japanese += "\(word) "
            }
        // Do any additional setup after loading the view.
        }
        printLabel.text = self.japanese
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hiraganaButtonTapped(_ sender: UIButton) {
        printLabel.text = "hiragana tapped"
    }
    
    @IBAction func katakanaButtonTapped(_ sender: UIButton) {
        printLabel.text = "katakana tapped"
    }
    
    func sendJapanese(selectedJapanese: [String]) {
        displayJapanese.append(selectedJapanese)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let japaneseCharactersTVC = segue.destination as! JapaneseCharactersTableViewController
        japaneseCharactersTVC.delegate = self
        if segue.identifier == "hiragana"{
            japaneseCharactersTVC.selectedType = JapaneseType.hiragana.rawValue
        }
        else if segue.identifier == "katakana" {
            japaneseCharactersTVC.selectedType = JapaneseType.katakana.rawValue
        }
        self.displayJapanese = [[]]
        self.japanese = ""
    }
    
    @IBAction func unwindToPracticeViewController(_ segue: UIStoryboardSegue) {
    }
}
