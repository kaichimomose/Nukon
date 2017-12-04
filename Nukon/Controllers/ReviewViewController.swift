//
//  ReviewViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/12/02.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var navigationTitle: String!
    var wordsLearnt: [WordLearnt]!
    var sectionData = [Int32: [WordLearnt]]()
    var sectionDataSort = [Int32]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.navigationTitle
        // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        self.calculateAccuracyRate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //calculate accuracy rate
    func calculateAccuracyRate() {
        for wordLearnt in wordsLearnt {
            let accuracyRate = wordLearnt.numberOfCorrect * 100 / (wordLearnt.numberOfCorrect + wordLearnt.numberOfWrong)
            // find key(accuracyRate) in sectionData, and append wordLearnt or insert key-value
            if self.sectionData[accuracyRate] != nil {
                self.sectionData[accuracyRate]?.append(wordLearnt)
            } else {
                self.sectionData[accuracyRate] = [wordLearnt]
                self.sectionDataSort.append(accuracyRate)
            }
            
        }
        //sort sectionData numerical order
        self.sectionDataSort.sort()
        //sort [wordLearnt] japanese sounds order
        for (key, value) in self.sectionData {
            let sortedValue = value.sorted { a,b in
                return a.word! < b.word!
            }
            //update sectionData dic
            self.sectionData[key] = sortedValue
        }
    }
}

extension ReviewViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let accuracyRate = self.sectionDataSort[section]
        return sectionData[accuracyRate]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Review", for: indexPath) as! ReviewCollectionReusableView
        let section = indexPath.section
        let accuracyRate = self.sectionDataSort[section]
        
        headerView.accuracyRateLabel.text = "Accuracy Rate: \(accuracyRate)%"
        if accuracyRate > 50{
            let float = 1.0 - CGFloat(accuracyRate)/100
            headerView.layer.backgroundColor = UIColor(red: float*2, green: 1.0, blue: 0.0, alpha: 1).cgColor
            
        } else {
            let float = CGFloat(accuracyRate)/100
            headerView.layer.backgroundColor = UIColor(red: 1.0, green: float*2, blue: 0.0, alpha: 1).cgColor
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewJapaneseCharacterCell", for: indexPath) as! ReviewJapaneseCharactersCollectionViewCell
        let row = indexPath.row
        let section = indexPath.section
        let accuracyRate = self.sectionDataSort[section]
        
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        let wordLearnt = sectionData[accuracyRate]![row]
        
        cell.japaneseCharacterLabel.text = wordLearnt.word
        cell.numberOfCorrectLabel.text = "\(Judge.correct.rawValue): \(wordLearnt.numberOfCorrect)"
        cell.numberOfWrongLabel.text = "\(Judge.wrong.rawValue): \(wordLearnt.numberOfWrong)"
        cell.soundLabel.text = wordLearnt.sound
        if wordLearnt.sound == "vowel" {
            cell.soundLabel.font = cell.soundLabel.font.withSize(18.0)
        }
        else {
            cell.soundLabel.font = cell.soundLabel.font.withSize(25.0)
        }
        if wordLearnt.type == JapaneseType.hiragana.rawValue {
            cell.japaneseTypeLabel.text =  "hi"
        }
        else if wordLearnt.type == JapaneseType.katakana.rawValue {
            cell.japaneseTypeLabel.text =  "ka"
        }
        else if wordLearnt.type == JapaneseType.voicedHiragana.rawValue {
            cell.japaneseTypeLabel.text =  "hi"
        }
        else if wordLearnt.type == JapaneseType.voicedKatakana.rawValue {
            cell.japaneseTypeLabel.text =  "ka"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        let accuracyRate = self.sectionDataSort[section]
        let wordLearnt = sectionData[accuracyRate]![row]

        let navigationVC = self.tabBarController?.viewControllers![1]
        let practiceVC = navigationVC?.childViewControllers.first as! PracticeViewController
        if wordLearnt.type == JapaneseType.hiragana.rawValue {
            practiceVC.japaneseType = .hiragana
        }
        else if wordLearnt.type == JapaneseType.katakana.rawValue {
            practiceVC.japaneseType = .katakana
        }
        else if wordLearnt.type == JapaneseType.voicedHiragana.rawValue {
            practiceVC.japaneseType = .voicedHiragana
        }
        else if wordLearnt.type == JapaneseType.voicedKatakana.rawValue {
            practiceVC.japaneseType = .voicedKatakana
        }
        practiceVC.sound = wordLearnt.sound
        self.tabBarController?.selectedIndex = 1
    }
}

extension ReviewViewController: UICollectionViewDelegateFlowLayout {
    // sets collectionview cell size and space between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // returns cell size, 3 cells in each row
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}

