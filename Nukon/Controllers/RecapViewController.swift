//
//  RecapViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/11.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation

class RecapViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var generatedCharacters: [Judge: [(String, String)]]?
    var correctWords = [(String, Int32, Int32, Int32)]()
    var wrongWords = [(String, Int32, Int32)]()
    var buffer: [AVAudioPCMBuffer]?
    var wordsLearnt = [WordLearnt]()
    var userData: UserData!
    var points = Int32()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //retrieve core data
        self.updateCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCoreData() {
        wordsLearnt = CoreDataHelper.retrieveWordLearnt()
        userData = CoreDataHelper.retrieveUserData()[0]
        for correctWord in generatedCharacters![.correct]! {
            var find = false
            var point = Int32(0)
            for wordLearnt in wordsLearnt {
                if wordLearnt.word == correctWord.1 {
                    wordLearnt.numberOfCorrect += 1
                    if wordLearnt.numberOfCorrect == 1 {
                        point = Int32(20)
                    } else {
                        point = Int32(10)
                    }
                    correctWords.append((correctWord.1, wordLearnt.numberOfCorrect, wordLearnt.numberOfWrong, point))
                    find = true
                    break
                }
            }
            if find == false{
                let newWordLearnt = CoreDataHelper.newWordLearnt()
                newWordLearnt.word = correctWord.1
                newWordLearnt.numberOfCorrect = 1
                point = Int32(20)
                correctWords.append((correctWord.1, newWordLearnt.numberOfCorrect, newWordLearnt.numberOfWrong, point))
            }
            self.points += point
        }
        for wrongWord in generatedCharacters![.wrong]! {
            var find = false
            for wordLearnt in wordsLearnt {
                if wordLearnt.word == wrongWord.0 {
                    wordLearnt.numberOfWrong += 1
                    wrongWords.append((wrongWord.0, wordLearnt.numberOfCorrect, wordLearnt.numberOfWrong))
                    find = true
                    break
                }
            }
            if find == false{
                let newWordLearnt = CoreDataHelper.newWordLearnt()
                newWordLearnt.word = wrongWord.0
                newWordLearnt.numberOfWrong = 1
                wrongWords.append((wrongWord.0, newWordLearnt.numberOfCorrect, newWordLearnt.numberOfWrong))
            }
        }
        self.userData.points += self.points
        CoreDataHelper.saveWordLearnt()
        CoreDataHelper.saveUserData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done" {
            //            for correctWord in generatedCharacters![.correct]! {
            //                var find = false
            //                for wordLearnt in wordsLearnt {
            //                    if wordLearnt.word == correctWord.1 {
            //                        wordLearnt.numberOfCorrect += 1
            //                        find = true
            //                        break
            //                    }
            //                }
            //                if find == false{
            //                    let newWordLearnt = CoreDataHelper.newWordLearnt()
            //                    newWordLearnt.word = correctWord.1
            //                    newWordLearnt.numberOfCorrect = 1
            //                }
            //            }
            //            for wrongWord in generatedCharacters![.wrong]! {
            //                var find = false
            //                for wordLearnt in wordsLearnt {
            //                    if wordLearnt.word == wrongWord.1 {
            //                        wordLearnt.numberOfWrong += 1
            //                        find = true
            //                        break
            //                    }
            //                }
            //                if find == false{
            //                    let newWordLearnt = CoreDataHelper.newWordLearnt()
            //                    newWordLearnt.word = wrongWord.0
            //                    newWordLearnt.numberOfWrong = 1
            //                }
            //            }
            //            let userPoints = self.userData.points + self.points
            //            self.userData.points = userPoints
            //            CoreDataHelper.saveWordLearnt()
            //            CoreDataHelper.saveUserData()
        }
    }
}

extension RecapViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return generatedCharacters![.wrong]!.count
        }
        else {
            return generatedCharacters![.correct]!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Recap", for: indexPath) as! RecapCollectionReusableView
        
        if indexPath.section == 0 {
            
            headerView.wrongOrCorrectLabel.text = "Wrong"
            headerView.layer.backgroundColor = UIColor.red.cgColor
            
            return headerView
        }
        else {
            
            headerView.wrongOrCorrectLabel.text = "Correct (+\(self.points) points)"
            headerView.layer.backgroundColor = UIColor.green.cgColor
            
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JapaneseCharacterCell", for: indexPath) as! JapaneseCharactersCollectionViewCell
        let row = indexPath.row
        
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        if indexPath.section == 0 {
            cell.characterLabel.text = wrongWords[row].0//generatedCharacters![.wrong]![row].0
            cell.numberOfCorrectLabel.text = "⭕️: \(wrongWords[row].1)"
            cell.numberOfWrongLabel.text = "❌: \(wrongWords[row].2)"
            cell.bonusLabel.isHidden = true
        }
        else {
            cell.characterLabel.text = correctWords[row].0//generatedCharacters![.correct]![row].0
            cell.numberOfCorrectLabel.text = "⭕️: \(correctWords[row].1)"
            cell.numberOfWrongLabel.text = "❌: \(correctWords[row].2)"
            cell.bonusLabel.isHidden = true
            if correctWords[row].3 == 20 {
                cell.bonusLabel.isHidden = false
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let textToSpeak = AVSpeechUtterance(string: generatedCharacters![.wrong]![row].0)
            textToSpeak.rate = 0.2
            let numberOfSeconds = 10.0
            textToSpeak.preUtteranceDelay = numberOfSeconds
            let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
            let speak = AVSpeechSynthesizer()
            textToSpeak.voice = speakerVoice
            speak.delegate = self
            speak.speak(textToSpeak)
            
            let analysisVC  = storyboard?.instantiateViewController(withIdentifier: "AnalysisViewController") as! AnalysisViewController
            // sends dictionaly of generated character by voice recognition to RecapViewController
            analysisVC.generatedCharacter = self.generatedCharacters![.wrong]![row]
            analysisVC.buffer = self.buffer![row]
            // goes to RecapViewController
            self.navigationController?.pushViewController(analysisVC, animated: true)
        }
    }
}

extension RecapViewController: UICollectionViewDelegateFlowLayout {
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

