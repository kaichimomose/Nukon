//
//  JapaneseCharacterTableViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class JapaneseCharactersTableViewController: UITableViewController, AlertPresentable {
    
    var japaneseList = [Japanese]()
    var selectedType: JapaneseType?
    var selectedJapaneseList = [Japanese]()
    var sectionData = [Int: [Japanese]]()
    var posibilitiesList = AllPosibilities().allPosibilitiesList
    var selectedPosibilitiesList = [Posibilities]()
    
    weak var delegate: JapaneseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseJapaneseCharacterType(type: selectedType!)
        self.title = self.selectedType?.rawValue
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.sectionData = [0: [], 1: japaneseList]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseJapaneseCharacterType(type: JapaneseType) {
        switch type {
        case .hiragana:
            self.japaneseList = JapaneseCharacters().hiraganaList
        case .katakana:
            self.japaneseList = JapaneseCharacters().katakanaList
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedSoundsHeaderTableViewCell") as! SelectedSoundsHeaderTableViewCell
            cell.selectedJapanese = self.selectedJapaneseList
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell")
            cell?.layer.backgroundColor = UIColor.gray.cgColor
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    /////
    
    /////table view cell functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (sectionData[section]!.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JapaneseCharactersTableViewCell", for: indexPath) as! JapaneseCharactersTableViewCell
        let row = indexPath.row
        cell.soundLabel.layer.cornerRadius = 20
        cell.soundLabel.layer.borderWidth = 1
        cell.soundLabel.layer.borderColor = UIColor.lightGray.cgColor
        cell.soundLabel.text = japaneseList[row].sound
        if japaneseList[row].select != true {
            cell.layer.backgroundColor = UIColor.white.cgColor
        }
        if row == 0 {
            cell.soundLabel.font = cell.soundLabel.font.withSize(14.0)
        }
        else{
            cell.soundLabel.font = cell.soundLabel.font.withSize(30.0)
        }
        let words = japaneseList[row].letters.joined(separator: " ")
        cell.japaneseCharactersLabel.text = words
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! JapaneseCharactersTableViewCell
        let row = indexPath.row
        let selectedJapanese = japaneseList[row]
        let posibilities = posibilitiesList[row]
        if japaneseList[row].select != true {
            cell.layer.backgroundColor = UIColor.blue.cgColor
            selectedJapaneseList.append(selectedJapanese)
            selectedPosibilitiesList.append(posibilities)
            print(selectedJapaneseList)
            print(selectedPosibilitiesList)
//            delegate?.sendJapanese(selectedJapanese: selectedJapanese)
            japaneseList[row].select = true
        }
        else {
            cell.layer.backgroundColor = UIColor.white.cgColor
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
    //////
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done"{
            // show alert message if users do not choose any cells
            if selectedJapaneseList.count == 0 {
                selectAlert()
            }
            else {
                for i in 0...japaneseList.count - 1 {
                    japaneseList[i].select = false
                }
                let showCharactersVC = segue.destination as! ShowCharactersViewController
                showCharactersVC.list = selectedJapaneseList
                showCharactersVC.selectedType = self.selectedType
                showCharactersVC.posibilitiesList = selectedPosibilitiesList
            }
        }
    }
    
    @IBAction func unwindToJapaneseCharactersTableViewController(_ segue: UIStoryboardSegue) {
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
