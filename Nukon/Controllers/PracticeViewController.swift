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
    @IBOutlet weak var button: UIButton!
    
    var displayJapanese = [[String]]()
    var japanese = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displayJapanese = [[]]
        
    }
    
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
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        printLabel.text = "button tapped"
    }
    
    func sendJapanese(selectedJapanese: [String]) {
        displayJapanese.append(selectedJapanese)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "button"{
            let japaneseCharactersTVC = segue.destination as! JapaneseCharactersTableViewController
            japaneseCharactersTVC.delegate = self
            self.displayJapanese = [[]]
            self.japanese = ""
        }
        
    }
    
    @IBAction func unwindToPracticeViewController(_ segue: UIStoryboardSegue) {
    }
}
