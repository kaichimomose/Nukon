//
//  RecapViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/11.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class RecapViewController: UIViewController {

    @IBOutlet weak var choosedCharactersLabel: UILabel!
    @IBOutlet weak var generatedCharactersLabel: UILabel!
    
    var choosedCharacters: [Japanese]?
    var characters = ""
    var generatedCharacters: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for listOfCharacters in choosedCharacters!{
            characters += "「" + listOfCharacters.letters.joined() + "」"
        }
        choosedCharactersLabel.text = characters
        generatedCharactersLabel.text = generatedCharacters
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
