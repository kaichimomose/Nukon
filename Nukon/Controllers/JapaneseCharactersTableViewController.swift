//
//  JapaneseCharacterTableViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class JapaneseCharactersTableViewController: UITableViewController {
    
    var japaneseList = [Japanese]()
    var selectedType: String?
    var selectedJapaneseList = [[String]]()
    
    var hiraganaList = [
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "vowel", letters: ["あ", "い", "う", "え", "お"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "K sound", letters: ["か", "き", "く", "け", "こ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "S sound", letters: ["さ", "し", "す", "せ", "そ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "T sound", letters: ["た", "ち", "つ", "て", "と"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "N sound", letters: ["な", "に", "ぬ", "ね", "の", "ん"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "H sound", letters: ["は", "ひ", "ふ", "へ", "ほ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "M sound", letters: ["ま", "み", "む", "め", "も"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "Y sound", letters: ["や", "　", "ゆ","　", "よ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "R sound", letters: ["ら", "り", "る", "れ", "ろ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "W sound", letters: ["わ", "　", "　", "　", "を"])
        ]
    
    var katakanaList = [
        Japanese(select: false, type: JapaneseType.katakana.rawValue, sound: "vowel", letters: ["ア", "イ", "ウ", "エ", "オ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "K sound", letters: ["カ", "キ", "ク", "ケ", "コ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "S sound", letters: ["サ", "シ", "ス", "セ", "ソ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "T sound", letters: ["タ", "チ", "ツ", "テ", "ト"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "N sound", letters: ["ナ", "ニ", "ヌ", "ネ", "ノ", "ン"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "H sound", letters: ["ハ", "ヒ", "フ", "ヘ", "ホ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "M sound", letters: ["マ", "ミ", "ム", "メ", "モ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "Y sound", letters: ["ヤ", "　", "ユ","　", "ヨ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "R sound", letters: ["ラ", "リ", "ル", "レ", "ロ"]),
        Japanese(select: false, type: JapaneseType.hiragana.rawValue, sound: "W sound", letters: ["ワ", "　", "　", "　", "ヲ"])
    ]
    
    weak var delegate: JapaneseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseJapaneseCharacterType()
        self.title = self.selectedType
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseJapaneseCharacterType() {
        if self.selectedType == JapaneseType.hiragana.rawValue {
            self.japaneseList =  self.hiraganaList
        }
        else {
            self.japaneseList =  self.katakanaList
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return japaneseList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JapaneseCharactersTableViewCell", for: indexPath) as! JapaneseCharactersTableViewCell
        var words = ""
        cell.soundLabel.text = japaneseList[indexPath.row].sound
        for letter in japaneseList[indexPath.row].letters {
            words += letter + " "
        }
        cell.japaneseCharactersLabel.text = words
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if japaneseList[indexPath.row].select != true {
            let selectedJapanese = japaneseList[indexPath.row].letters
            selectedJapaneseList.append(selectedJapanese)
//            delegate?.sendJapanese(selectedJapanese: selectedJapanese)
            japaneseList[indexPath.row].select = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done"{
            let showCharactersVC = segue.destination as! ShowCharactersViewController
            showCharactersVC.list = selectedJapaneseList
            //showCharactersVC.viewDidLoad()
        }
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
