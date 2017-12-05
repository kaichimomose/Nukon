//
//  ReviewTableViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/12/05.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {
    
    var wordsLearnt: [WordLearnt]!
    var normalHiraganaWordsLearnt = [WordLearnt]() //wordlearnt instances whose japanese type is hiragana or katakana
    var voicedHiraganaWordsLearnt = [WordLearnt]() //wordlearnt instances whose japanese type is voiced-hiragana or voiced-katakana
    var yVowelHiraganaWordsLearnt = [WordLearnt]() //wordlearnt instances whose japanese type is y-vowel-hiragana or y-vowel-katakana
    var normalKatakanaWordsLearnt = [WordLearnt]() //wordlearnt instances whose japanese type is hiragana or katakana
    var voicedKatakanaWordsLearnt = [WordLearnt]() //wordlearnt instances whose japanese type is voiced-hiragana or voiced-katakana
    var yVowelKatakanaWordsLearnt = [WordLearnt]() //wordlearnt instances whose japanese type is y-vowel-hiragana or y-vowel-katakana
    var sectionData = [0: [[WordLearnt]](), 1: [[WordLearnt]]()]
    
    func categorizingWordsLearnt() {
        for wordLearnt in self.wordsLearnt {
            //distinguishs japanese type
            var japaneseType: JapaneseType!
            if wordLearnt.type == JapaneseType.hiragana.rawValue {
                japaneseType = .hiragana
            }
            else if wordLearnt.type == JapaneseType.katakana.rawValue {
                japaneseType = .katakana
            }
            else if wordLearnt.type == JapaneseType.voicedHiragana.rawValue {
                japaneseType = .voicedHiragana
            }
            else if wordLearnt.type == JapaneseType.voicedKatakana.rawValue {
                japaneseType = .voicedKatakana
            }
            else if wordLearnt.type == JapaneseType.yVowelHiragana.rawValue {
                japaneseType = .yVowelHiragana
            }
            else if wordLearnt.type == JapaneseType.yVowelKatakana.rawValue {
                japaneseType = .yVowelKatakana
            }
            //categorizes wordLearnt object among 3 types based on japaneseType
            switch japaneseType {
            case .hiragana:
                normalHiraganaWordsLearnt.append(wordLearnt)
            case .voicedHiragana:
                voicedHiraganaWordsLearnt.append(wordLearnt)
            case .yVowelHiragana:
                yVowelHiraganaWordsLearnt.append(wordLearnt)
            case .katakana:
                normalKatakanaWordsLearnt.append(wordLearnt)
            case .voicedKatakana:
                voicedKatakanaWordsLearnt.append(wordLearnt)
            case .yVowelKatakana:
                yVowelKatakanaWordsLearnt.append(wordLearnt)
            default:
                normalHiraganaWordsLearnt.append(wordLearnt)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionData[section]!.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
