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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        haraganaButton.layer.shadowRadius = 3.5
        katakanaButton.layer.shadowRadius = 2.5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hiraganaButtonTapped(_ sender: UIButton) {
        print("hiragana tapped")
    }
    
    @IBAction func katakanaButtonTapped(_ sender: UIButton) {
        print("katakana tapped")
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
