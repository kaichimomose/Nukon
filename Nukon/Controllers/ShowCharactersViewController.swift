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
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxChara = numberOfCharacters()
        characterLabel.text = orderCharacter()
        countCharacters.text = "\(counter)/\(maxChara)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        print("tapped")
        if counter < maxChara {
            characterLabel.text = orderCharacter()
            countCharacters.text = "\(counter)/\(maxChara)"
        }
        else {
            characterLabel.text = "END"
        }
    }
    
    func numberOfCharacters() -> Int {
        if let list = list {
            var numberOfCharacters = 0
            for soundArray in list {
                let lengthOfSoundArray = soundArray.count
                numberOfCharacters += lengthOfSoundArray
            }
            return numberOfCharacters
        } else {return 0}
    }
    
    func randomCharacter() -> String {
        if let list = list {
            let soundIndex = Int(arc4random()) % list.count
            let vowelIndex = Int(arc4random()) % list[soundIndex].count
            appearedCharacters.append(list[soundIndex][vowelIndex])
            return list[soundIndex][vowelIndex]
        } else {return ""}
        
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
