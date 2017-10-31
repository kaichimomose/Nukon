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
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterLabel.text = randomCharacter()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        print("tapped")
        findNewCharacter()
    }
    
    func randomCharacter() -> String {
        if let list = list {
            let soundIndex = Int(arc4random()) % list.count
            let vowelIndex = Int(arc4random()) % list[soundIndex].count
            appearedCharacters.append(list[soundIndex][vowelIndex])
            return list[soundIndex][vowelIndex]
        } else {return ""}
        
    }
    
    func findNewCharacter() {
        let willAppearCharacter = randomCharacter()
        for character in appearedCharacters {
            if character == willAppearCharacter {
                findNewCharacter()
            }
            else {
                characterLabel.text = willAppearCharacter
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
