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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let japaneseCharactersTVC = segue.destination as! JapaneseCharactersTableViewController
        if segue.identifier == "hiragana"{
            japaneseCharactersTVC.selectedType = JapaneseType.hiragana
        }
        else if segue.identifier == "katakana" {
            japaneseCharactersTVC.selectedType = JapaneseType.katakana
        }
    }
    
    @IBAction func unwindToPracticeViewController(_ segue: UIStoryboardSegue) {
    }
}
