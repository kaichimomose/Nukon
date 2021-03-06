//
//  JapaneseCharacterTableViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

enum ShowingStyle {
    case order
    case random
}

class JapaneseCharactersTableViewController: UITableViewController, AlertPresentable {
    
    var japaneseList = [Japanese]()
    var selectedType: JapaneseType!
    var selectedJapaneseList = [Japanese]()
    var selectedPosibilitiesList = [Posibilities]()
    var sectionData = [Int: [Japanese]]()
    
    var preSelectedSound: String?
    var preSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch self.selectedType {
        case .hiragana, .katakana:
            self.title = "Regular-sounds"
        case .voicedHiragana, .voicedKatakana:
            self.title = "Voiced-sounds"
        case .yVowelHiragana, .yVowelKatakana:
            self.title = "Y-vowel-sounds"
        default:
            self.title = ""
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.chooseJapaneseCharacterType(type: selectedType)
        self.sectionData = [0: [], 1: self.japaneseList]
        if let selectedSound = self.preSelectedSound {
            for index in 0...self.japaneseList.count {
                if self.japaneseList[index].sound == selectedSound {
                    self.preSelectedIndexPath = IndexPath(row: index, section: 1)
                    self.selectCell(indexPath: self.preSelectedIndexPath!)
                    break
                }
            }
        }
//        if let selectedIndexPath = self.preSelectedIndexPath {
//            let cell = self.tableView.cellForRow(at: selectedIndexPath)
//            cell?.layer.backgroundColor = UIColor.blue.cgColor
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseJapaneseCharacterType(type: JapaneseType) {
        // chooses hiragana or katakana based on users' choice
        switch type {
        case .hiragana:
            self.japaneseList = JapaneseCharacters().hiraganaList
        case .katakana:
            self.japaneseList = JapaneseCharacters().katakanaList
        case .voicedHiragana:
            self.japaneseList = JapaneseCharacters().voicedHiraganaList
        case .voicedKatakana:
            self.japaneseList = JapaneseCharacters().voicedKatakanaList
        case .yVowelHiragana:
            self.japaneseList = JapaneseCharacters().yVowelHiraganaList
        case .yVowelKatakana:
            self.japaneseList = JapaneseCharacters().yVowelKatakanaList
        }
    }

    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    //////Header cell functions
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            // the header that shows what sound user select
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedSoundsHeaderTableViewCell") as! SelectedSoundsHeaderTableViewCell
            cell.selectedJapanese = self.selectedJapaneseList
            return cell
        }
        else {
            // the header that shows vowels (a, i, u, e, o)
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! JapaneseCharactersTableViewCell
            cell.layer.backgroundColor = UIColor(red: 0/255, green: 166/255, blue: 237/255, alpha: 1).cgColor
            let width = self.tableView.frame.width / 8
            cell.vowelALabel.frame.size.width = width
            
            cell.vowelALabel.layer.cornerRadius = width / 2
            cell.vowelALabel.layer.borderWidth = 1
            cell.vowelALabel.layer.borderColor = UIColor.black.cgColor
            
            cell.vowelILabel.layer.cornerRadius = width / 2
            cell.vowelILabel.layer.borderWidth = 1
            cell.vowelILabel.layer.borderColor = UIColor.black.cgColor
            
            cell.vowelULabel.layer.cornerRadius = width / 2
            cell.vowelULabel.layer.borderWidth = 1
            cell.vowelULabel.layer.borderColor = UIColor.black.cgColor
            
            cell.vowelELabel.layer.cornerRadius = width / 2
            cell.vowelELabel.layer.borderWidth = 1
            cell.vowelELabel.layer.borderColor = UIColor.black.cgColor
            
            cell.vowelOLabel.layer.cornerRadius = width / 2
            cell.vowelOLabel.layer.borderWidth = 1
            cell.vowelOLabel.layer.borderColor = UIColor.black.cgColor
            
            cell.vowelVoidLabel.layer.cornerRadius = width / 2
            cell.vowelVoidLabel.layer.borderWidth = 1
            cell.vowelVoidLabel.layer.borderColor = UIColor.black.cgColor
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // sets height of header cells
        return 70
    }
    /////
    
    /////table view cell functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns the number of table view rows
        return (sectionData[section]!.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JapaneseCharactersTableViewCell", for: indexPath) as! JapaneseCharactersTableViewCell
        let row = indexPath.row
        // sets layers
        cell.soundLabel.layer.cornerRadius = cell.soundLabel.frame.width / 2
        cell.soundLabel.layer.borderWidth = 1
        cell.soundLabel.layer.borderColor = UIColor.black.cgColor
        let showSound = japaneseList[row].sound
        cell.soundLabel.text = showSound
        if japaneseList[row].select != true {
            // changes the background color from blue to white when returning from ShowCharactersView to here
            cell.backgroundColor = .white
        } else {
            //changes the background color of preselected sound row to blue
            cell.backgroundColor = UIColor(red: 127/255, green: 170/255, blue: 116/255, alpha: 1)
        }
        // adjusts font size based on rows
        if showSound == "vowel" {
            cell.soundLabel.font = cell.soundLabel.font.withSize(14.0)
        }
        else{
            cell.soundLabel.font = cell.soundLabel.font.withSize(30.0)
        }
        // makes one string from character letters lists
        cell.letters = japaneseList[row].letters
        let width = self.tableView.frame.width / 8
        cell.vowelALabel.frame.size.width = width
        cell.consonantView.frame.size.width = width
        
        if cell.vowelALabel.text != "　" {
            cell.vowelALabel.layer.cornerRadius = 2
            cell.vowelALabel.layer.borderWidth = 1
            cell.vowelALabel.layer.borderColor = UIColor.black.cgColor
        }
        
        if cell.vowelILabel.text != "　" {
            cell.vowelILabel.layer.cornerRadius = 2
            cell.vowelILabel.layer.borderWidth = 1
            cell.vowelILabel.layer.borderColor = UIColor.black.cgColor
        }
        
        if cell.vowelULabel.text != "　" {
            cell.vowelULabel.layer.cornerRadius = 2
            cell.vowelULabel.layer.borderWidth = 1
            cell.vowelULabel.layer.borderColor = UIColor.black.cgColor
        }
        
        if cell.vowelELabel.text != "　" {
            cell.vowelELabel.layer.cornerRadius = 2
            cell.vowelELabel.layer.borderWidth = 1
            cell.vowelELabel.layer.borderColor = UIColor.black.cgColor
        }
        if cell.vowelOLabel.text != "　" {
            cell.vowelOLabel.layer.cornerRadius = 2
            cell.vowelOLabel.layer.borderWidth = 1
            cell.vowelOLabel.layer.borderColor = UIColor.black.cgColor
        }
        
        if cell.vowelVoidLabel.text != "　" {
            cell.vowelVoidLabel.layer.cornerRadius = 2
            cell.vowelVoidLabel.layer.borderWidth = 1
            cell.vowelVoidLabel.layer.borderColor = UIColor.black.cgColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCell(indexPath: indexPath)
    }
    //////
    
    func selectCell(indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let row = indexPath.row
        let selectedJapanese = japaneseList[row]
        var posibilities: Posibilities
        //switchs posibilituieslist depending on japanesetype
        switch self.selectedType {
        case .hiragana, .katakana:
            posibilities = AllPosibilities().allPosibilitiesList[row]
        case .voicedHiragana, .voicedKatakana:
            posibilities = AllPosibilities().allVoicedPosibilitiesList[row]
        case .yVowelHiragana, .yVowelKatakana:
            posibilities = AllPosibilities().allYVowelPosibilitiesList[row]
        default:
            posibilities = AllPosibilities().allPosibilitiesList[row]
        }
        
        if japaneseList[row].select != true {
            // once being selected, changes the background color to blue
            cell?.layer.backgroundColor = UIColor.blue.cgColor
            selectedJapaneseList.append(selectedJapanese)
            selectedPosibilitiesList.append(posibilities)
            print(selectedJapaneseList)
            print(selectedPosibilitiesList)
            // avoids choosing the same row
            japaneseList[row].select = true
        }
        else {
            // changes the background color from blue to white when choose the row that has been already choosen
            cell?.layer.backgroundColor = UIColor.white.cgColor
            // remove the row form selectedList
            for index in 0...selectedJapaneseList.count {
                if selectedJapaneseList[index].letters == selectedJapanese.letters {
                    selectedJapaneseList.remove(at: index)
                    selectedPosibilitiesList.remove(at: index)
                    break
                }
            }
            japaneseList[row].select = false
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func practiceButtonTapped(_ sender: Any) {
        // show alert message if users do not choose any cells
        if selectedJapaneseList.count == 0 {
            selectAlert()
        }
        else {
            //
            for i in 0...japaneseList.count - 1 {
                japaneseList[i].select = false
            }
            // sends lists to ShowCharactersViewController
            func goToShowCharactersVC(_ showingStyle: ShowingStyle) {
                let showCharactersVC = storyboard?.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
                showCharactersVC.list = selectedJapaneseList
                showCharactersVC.posibilitiesList = selectedPosibilitiesList
                showCharactersVC.japaneseType = selectedType
                showCharactersVC.showingStyle = showingStyle
                self.navigationController?.pushViewController(showCharactersVC, animated: true)
            }
            
            goToShowCharactersVCAlert(closure: goToShowCharactersVC(_:))
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancel" {
            let practiceVC = segue.destination as! PracticeViewController
            practiceVC.japaneseType = nil
            practiceVC.sound = nil
        }
    }
    
    @IBAction func unwindToJapaneseCharactersTableViewController(_ segue: UIStoryboardSegue) {
    }

}
