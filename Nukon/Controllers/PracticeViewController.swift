//
//  PracticeViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/09.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

enum Order {
    case orderly
    case randomly
}

protocol CharacterDelegate: class {
    func randomCharacter()
    func orderCharacter()
    func dismissPracticeView()
    func updateCoreData(confidence: Int)
}

class PracticeViewController: UIViewController, CharacterDelegate {

    //MARK: - Properties
    let speakingCellReuseIdentifer = "SpeakingCell"
    let writingCellReuseIdentifer = "WritingCell"
    var backgroundColor: UIColor!
    
    var order: Order = .orderly
    
    var japaneseType: JapaneseType!
    var japaneseList: [Japanese]?
    var japaneseDict: [String: [String?]]?
    
    var soundAndLettersList = [(String, [String?])]()
    var soundsList = JapaneseCharacters.soundsList
    
    var shownCharacter = ""
    var sound = ""
    
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var totalNumberOfCharacter: Int = 0
    var currentNumber: Int = 0
    
    //coredata management
    let coreDataStack = CoreDataStack.instance
    var characterCoreDataDict: [String: WordLearnt]!
    
    //MARK: -Outlets
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    @IBOutlet weak var countCharactersLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.backgroundColor
        
        menuBar.practiceVC = self
        menuBarCollectionView.delegate = menuBar
        menuBarCollectionView.dataSource = menuBar
        menuBarCollectionView.backgroundColor = self.backgroundColor
        
        let selectedIndexpath = NSIndexPath(row: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexpath as IndexPath, animated: false, scrollPosition: [])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(UINib.init(nibName: "SpeakingCell", bundle: .main), forCellWithReuseIdentifier: speakingCellReuseIdentifer)
        collectionView.register(UINib.init(nibName: "WritingCell", bundle: .main), forCellWithReuseIdentifier: writingCellReuseIdentifer)
        
        if let japaneseDict = self.japaneseDict {
            if let japaneseList = self.japaneseList {
                for japanese in japaneseList{
                    if let letters = japaneseDict[japanese.sound] {
                        // create list of tuples ex.) ("vowel", [あ, い, う, え, お])
                        self.soundAndLettersList.append((japanese.sound, letters))
                    }
                }
            } else {
                self.order = .randomly
                for (consonant, letters) in japaneseDict {
                    self.soundAndLettersList.append((consonant, letters))
                }
            }
        }
        
        self.totalNumberOfCharacter = numberOfCharacters()
        // choose first chracter
        switch self.order {
        case .orderly:
            
//            self.commentLabel.alpha = 0.0
//            self.nextCharacterButton.alpha = 0.0
//            self.nextCharacterButton.isEnabled = false
            
            orderCharacter()
        case .randomly:
            randomCharacter()
        }
        
        self.countCharactersLabel.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollToItemIndexPath(menuindex: Int) {
        collectionView.reloadData()
        let indexPath = NSIndexPath(item: 0, section: menuindex)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func numberOfCharacters() -> Int {
        // return total number of characters that are in the list
        var numberOfCharacters = 0
        guard let japaneseDict = self.japaneseDict else {return 0}
        for value in japaneseDict.values {
            for character in value {
                if character != nil {
                    numberOfCharacters += 1
                }
            }
        }
        return numberOfCharacters
    }
    
    func randomCharacter() {
        // chooses a character randomly, returns it
        // generates random numbers
        let soundIndex = Int(arc4random()) % self.soundAndLettersList.count
        let (sound, letters) = self.soundAndLettersList[soundIndex]
        // gets sounds
        var sounds = soundsList[sound]
        print(sounds!)
        let vowelIndex = Int(arc4random()) % letters.count
        // picks a character with random numbers
        print(vowelIndex)
        let character = letters[vowelIndex]
        if let showCharacter = character {
            let currectsound = sounds![vowelIndex]
            print(currectsound)
            // picks a list of possible characters of the picked character
            self.sound = currectsound
            
            // deletes selected character
            self.soundAndLettersList[soundIndex].1.remove(at: vowelIndex)
            self.soundsList[sound]?.remove(at: vowelIndex)
            if self.soundAndLettersList[soundIndex].1.count == 0 {
                self.soundAndLettersList.remove(at: soundIndex)
            }
            print(soundAndLettersList)
            //updates currentNumber
            self.currentNumber += 1
            self.shownCharacter = showCharacter
            self.countCharactersLabel.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
            self.collectionView.reloadData()
        } else {
            // deletes selected character
            self.soundAndLettersList[soundIndex].1.remove(at: vowelIndex)
            self.soundsList[sound]?.remove(at: vowelIndex)
            if self.soundAndLettersList[soundIndex].1.count == 0 {
                self.soundAndLettersList.remove(at: soundIndex)
            }
            randomCharacter()
        }
    }
    
    // shows a character orderly
    func orderCharacter() {
        
        let numberOfCharactersInList = soundAndLettersList[self.soundIndexCounter].1.count
        if self.vowelIndexCounter == numberOfCharactersInList {
            self.vowelIndexCounter = 0
            self.soundIndexCounter += 1
            if self.soundIndexCounter == soundAndLettersList.count {
                self.vowelIndexCounter = 0
                self.soundIndexCounter = 0
            }
        }
        let character = soundAndLettersList[self.soundIndexCounter].1[self.vowelIndexCounter]
        if let showCharacter = character {
            let soundType = soundAndLettersList[self.soundIndexCounter].0
            //makes correctsound
            let currectsound = soundsList[soundType]![self.vowelIndexCounter]
            print(currectsound)
            
            self.vowelIndexCounter += 1
            
            self.sound = currectsound
            
            //updates currentNumber
            self.currentNumber += 1
            self.shownCharacter = showCharacter
            self.countCharactersLabel.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
            self.collectionView.reloadData()
        }else {
            self.vowelIndexCounter += 1
            orderCharacter()
        }
    }
    
    func dismissPracticeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateCoreData(confidence: Int) {
        let word = characterCoreDataDict[self.shownCharacter]
        guard let wordLearnt = word else {return}
        let backgroundEntity = coreDataStack.privateContext.object(with: wordLearnt.objectID) as! WordLearnt
        backgroundEntity.confidenceCounter = Int16(confidence)
        coreDataStack.saveTo(context: coreDataStack.privateContext)
        coreDataStack.viewContext.refresh(wordLearnt, mergeChanges: true)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismissPracticeView()
    }
    
}

extension PracticeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: speakingCellReuseIdentifer, for: indexPath) as! SpeakingCell
            cell.delegate = self
            cell.backgroundColor = self.backgroundColor
            cell.shownCharacter = self.shownCharacter
            cell.sound = self.sound
            cell.order = .orderly
            cell.currentNumber = self.currentNumber
            cell.totalNumberOfCharacter = self.totalNumberOfCharacter
            cell.judge = Judge.yet
            cell.comment = Comment.start
            cell.buttonTitle = ButtonTitle.start
            cell.updateLabels()
            cell.moveCharacter()
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: writingCellReuseIdentifer, for: indexPath) as! WritingCell
            cell.delegate = self
            cell.backgroundColor = self.backgroundColor
            cell.shownCharacter = self.shownCharacter
            cell.sound = self.sound
            cell.order = .orderly
            cell.currentNumber = self.currentNumber
            cell.totalNumberOfCharacter = self.totalNumberOfCharacter
            cell.judge = Judge.yet
            cell.updateLabels()
            return cell
        }
    }
}
