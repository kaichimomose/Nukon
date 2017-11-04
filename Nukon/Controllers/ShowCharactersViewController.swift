//
//  ShowCharactersViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/30.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class ShowCharactersViewController: UIViewController {
    
    var list: [[String]]?
    var appearedCharacters = [String]()
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var counter: Int = 0
    var maxChara: Int = 0
    var mutableList = [[String]]()
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characterLabel.layer.cornerRadius = 6
        self.characterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.characterLabel.layer.borderWidth = 1
        maxChara = numberOfCharacters()
        if let list = list {
            mutableList = list
        }
        characterLabel.text = randomCharacter()
        countCharacters.text = "\(counter)/\(maxChara)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        if counter < maxChara {
            characterLabel.text = randomCharacter()
            countCharacters.text = "\(counter)/\(maxChara)"
        }
        else {
            characterLabel.text = "END"
        }
    }
    
    func numberOfCharacters() -> Int {
        if let list = list {
            var numberOfCharacters = 0
            for i in 0...list.count - 1 {
                for j in 0...list[i].count - 1 {
                    if list[i][j] != "　" {
                        numberOfCharacters += 1
                    }
                }
            }
            return numberOfCharacters
        } else {return 0}
    }
    
    func randomCharacter() -> String {
        let soundIndex = Int(arc4random()) % mutableList.count
        let vowelIndex = Int(arc4random()) % mutableList[soundIndex].count
        var showCharacter = mutableList[soundIndex][vowelIndex]
        if showCharacter == "　" {
            showCharacter = randomCharacter()
        }
        else {
            mutableList[soundIndex].remove(at: vowelIndex)
            if mutableList[soundIndex] == [] {
                mutableList.remove(at: soundIndex)
            }
            counter += 1
        }
        return showCharacter
    }
    
    func orderCharacter() -> String {
        if let list = list {
            if vowelIndexCounter == list[soundIndexCounter].count {
                vowelIndexCounter = 0
                soundIndexCounter += 1
                if soundIndexCounter == list.count {
                    vowelIndexCounter = 0
                    soundIndexCounter = 0
                }
            }
            counter += 1
            vowelIndexCounter += 1
            return list[soundIndexCounter][vowelIndexCounter - 1]
        } else {return ""}
    }
    
//    func findNewCharacter() {
//        let willAppearCharacter = randomCharacter()
//        for character in appearedCharacters {
//            if willAppearCharacter == character {
//                findNewCharacter()
//            }
//            else {
//                characterLabel.text = willAppearCharacter
//            }
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
