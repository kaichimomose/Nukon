//
//  RecapViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/11.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation

class RecapViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var japaneseType: JapaneseType!
    var showingStyle: ShowingStyle!
    var correctWords = [(String, Int32)]() //(character, point)
    var wrongWords = [String]() //
    var buffer: [AVAudioPCMBuffer]?
    var judgedCharacters: [Judge: [(String, String)]]? //(sound, character)
    var wordsLearnt = [WordLearnt]()
    var userDatas = [UserData]()
    var userData: UserData!
    var points = Int32()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //retrieve core data
        self.updateCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCoreData() {
        wordsLearnt = CoreDataHelper.retrieveWordLearnt()
        userDatas = CoreDataHelper.retrieveUserData()
        
        if userDatas == [] {
            userData = CoreDataHelper.newUserData()
        }
        else {
            userData = userDatas[0]
        }
        //find word in correctWord from coredata [WordLearnt], if found update number of correct and give point
        for (sound, character) in judgedCharacters![.correct]! {
            var find = false //flag to decide whether find or not
            var point = Int32(0)
            for wordLearnt in wordsLearnt {
                if wordLearnt.word == character {
                    wordLearnt.numberOfCorrect += 1
                    if wordLearnt.numberOfCorrect == 1 {
                        point = Int32(25)
                    } else {
                        point = Int32(10)
                    }
                    switch self.showingStyle {
                    case .random:
                        point = point * 2
                    default:
                        point = point * 1
                    }
                    //append
                    correctWords.append((character, point))
                    //update flag
                    find = true
                    break
                }
            }
            //if not found, insert word to coredata and give points
            if find == false{
                let newWordLearnt = CoreDataHelper.newWordLearnt()
                newWordLearnt.word = character
                newWordLearnt.numberOfCorrect = 1
                newWordLearnt.sound = sound
                newWordLearnt.type = japaneseType.rawValue
                point = Int32(25)
                switch self.showingStyle {
                case .random:
                    point = point * 2
                default:
                    point = point * 1
                }
                //append
                correctWords.append((character, point))
            }
            self.points += point
        }
        //find word in correctWord from coredata [WordLearnt], if found update number of wrong
        for (sound, character) in judgedCharacters![.wrong]! {
            var find = false //flag to decide whether find or not
            for wordLearnt in wordsLearnt {
                if wordLearnt.word == character {
                    wordLearnt.numberOfWrong += 1
                    wrongWords.append(character)
                    find = true
                    break
                }
            }
            //if not found, insert word to coredata
            if find == false{
                let newWordLearnt = CoreDataHelper.newWordLearnt()
                newWordLearnt.word = character
                newWordLearnt.numberOfWrong = 1
                newWordLearnt.sound = sound
                newWordLearnt.type = japaneseType.rawValue
                wrongWords.append(character)
            }
        }
        // updates userData point
        self.userData.points += self.points
        // saves core data
        CoreDataHelper.saveWordLearnt()
        CoreDataHelper.saveUserData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "done" {
            let practiceVC = segue.destination as! PracticeViewController
            practiceVC.japaneseType = nil
            practiceVC.sound = nil
        }
    }
}

extension RecapViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return judgedCharacters![.wrong]!.count
        }
        else {
            return judgedCharacters![.correct]!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Recap", for: indexPath) as! RecapCollectionReusableView
        
        if indexPath.section == 0 {
            
            headerView.wrongOrCorrectLabel.text = "Wrong (\(Judge.wrong.rawValue))"
            headerView.layer.backgroundColor = UIColor.red.cgColor
            
            return headerView
        }
        else {
            
            headerView.wrongOrCorrectLabel.text = "Correct (\(Judge.correct.rawValue)) (+\(self.points) points)"
            headerView.layer.backgroundColor = UIColor.green.cgColor
            
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JapaneseCharacterCell", for: indexPath) as! JapaneseCharactersCollectionViewCell
        let row = indexPath.row
        
        //cell layout
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        if indexPath.section == 0 {
            cell.characterLabel.text = wrongWords[row] // + " (" + generatedCharacters![.wrong]![row].2 + ")"//generatedCharacters![.wrong]![row].0
            cell.bonusLabel.isHidden = true
        }
        else {
            cell.characterLabel.text = correctWords[row].0 // + " (" + generatedCharacters![.correct]![row].2 + ")"//generatedCharacters![.correct]![row].0
            cell.bonusLabel.isHidden = true
            if correctWords[row].1 == 25 || correctWords[row].1 == 50 {
                cell.bonusLabel.text = "First Correct Bonus +\(correctWords[row].1)p"
                cell.bonusLabel.isHidden = false
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if indexPath.section == 0 {
            speakJapanese(string: wrongWords[row])
        }
        else {
            speakJapanese(string: correctWords[row].0)
        }
    }
    
    func speakJapanese(string: String) {
        let textToSpeak = AVSpeechUtterance(string: string)
        textToSpeak.rate = 0.01
        textToSpeak.volume = 1.0
        //        let numberOfSeconds = 10.0
        //        textToSpeak.preUtteranceDelay = numberOfSeconds
        let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        let speak = AVSpeechSynthesizer()
        textToSpeak.voice = speakerVoice
        //        speak.delegate = self
        speak.speak(textToSpeak)
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
