//
//  ReviewTableViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/12/05.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

enum JapaneseSoundsType: String {
    case regular = "regular-sounds"
    case voiced = "voiced-sounds"
    case yVowel = "y-vowel-sounds"
}

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
        self.sectionData = [0: [normalHiraganaWordsLearnt, voicedHiraganaWordsLearnt, yVowelHiraganaWordsLearnt], 1: [normalKatakanaWordsLearnt, voicedKatakanaWordsLearnt, yVowelKatakanaWordsLearnt]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categorizingWordsLearnt()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    //////Header cell functions
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewHeaderTableViewCell") as! ReviewHeaderTableViewCell
        var numberOfKana = 0
        for wordsLearnt in sectionData[section]! {
            numberOfKana += wordsLearnt.count
        }
        if section == 0 {
            // Hiragana Header
            cell.japaneseTypeLabel.text = "Hiragana: \(numberOfKana)"
            cell.backgroundColor = UIColor(red: 252/255, green: 203/255, blue: 201/255, alpha: 1)
            return cell
        }
        else {
            // Katakana Header
            cell.japaneseTypeLabel.text = "Katakana: \(numberOfKana)"
            cell.backgroundColor = UIColor(red: 98/255, green: 155/255, blue: 196/255, alpha: 1)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // sets height of header cells
        return 60
    }
    /////
    
    // cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionData[section]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let row = indexPath.row
        let section = indexPath.section
        let numberOfWordsLearnt = sectionData[section]![row].count
        if row == 0 {
            cell.soundsType = .regular
        }
        else if row == 1 {
            cell.soundsType = .voiced
        } else {
            cell.soundsType = .yVowel
        }
        cell.specificJapaneseTypeLabel.text = cell.soundsType.rawValue + ":"
        cell.numberOfWordsLabel.text = "\(numberOfWordsLearnt)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let row = indexPath.row
        let section = indexPath.section
        let wordsLearnt = sectionData[section]![row]
        if row == 0 {
            cell.soundsType = .regular
        }
        else if row == 1 {
            cell.soundsType = .voiced
        } else {
            cell.soundsType = .yVowel
        }
        let reviewVC = storyboard?.instantiateViewController(withIdentifier: "reviewViewController") as! ReviewViewController
        if section == 0 {
            reviewVC.navigationColor = UIColor(red: 252/255, green: 203/255, blue: 201/255, alpha: 1)
        } else {
            reviewVC.navigationColor = UIColor(red: 98/255, green: 155/255, blue: 196/255, alpha: 1)
        }
        reviewVC.title = cell.soundsType.rawValue
        reviewVC.wordsLearnt = wordsLearnt
        reviewVC.normalWordsLearnt = sectionData[section]![0]
        reviewVC.voicedWordsLearnt = sectionData[section]![1]
        reviewVC.yVowelWordsLearnt = sectionData[section]![2]
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @IBAction func unwindToReviewTableViewController(_ segue: UIStoryboardSegue) {
        self.navigationController?.navigationBar.barTintColor = .white
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
