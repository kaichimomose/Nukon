//
//  JapaneseCharactersCollectionViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/06.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import CoreData

protocol GetValueFromCollectionView {
    func getSelectedValue(selectedJapanese: [String: [String?]], selectedJpaneseCoreData: [String: WordLearnt])
    func getDeselectedValue(selectedJapanese: [String: [String?]], selectedJpaneseCoreData: [String: WordLearnt])
}

class JapaneseCharactersCollectionViewController: UIViewController, GetValueFromCollectionView {
    
    //MARK: - Properties
    var japaneseList = [Japanese]()
    var japaneseType: JapaneseType!
    
    var selectedJapanese = [String: [String?]]()
    var selectedJpaneseCoreData = [String: WordLearnt]()
    var consonantAndWordDict = [String: [String: WordLearnt]]()
    var consonantDict = [String: Consonant]()
    
    var unLockNextConsonant = [String: Bool]()
    var numberOfUnlockedCell: Int!
    
    let coreDataStack = CoreDataStack.instance
    
    let consonantViewCell = "ConsonantViewCell"
    let overViewCell = "OverViewCell"
    
    //MARK: - Outlets
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var practiceButton: UIButton!
    
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    
    @IBOutlet weak var menuBar: MenuBar!
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLable.text = japaneseType.rawValue
        
        menuBar.japaneseCharacterCVC = self
        menuBarCollectionView.delegate = menuBar
        menuBarCollectionView.dataSource = menuBar
        
        let selectedIndexpath = NSIndexPath(row: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexpath as IndexPath, animated: false, scrollPosition: [])
        
        //collectionview setting
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.alwaysBounceHorizontal = true
        collectionView.isScrollEnabled = false
//        collectionView.isPagingEnabled = true
        
        practiceButton.alpha = 0.5
        practiceButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.chooseJapaneseCharacterType(type: japaneseType)
        // Initialize Fetch Request\
        let fetchRequest: NSFetchRequest<Consonant> = Consonant.fetchRequest()
        // Add Specific type Descriptors
        fetchRequest.predicate = NSPredicate(format: "system == %@", japaneseType.rawValue)

        do {
            let result = try self.coreDataStack.viewContext.fetch(fetchRequest)
            var unlockedcellCounter = 1
            for item in result {
                guard let consonant = item.consonant else {return}
                let words = item.words?.allObjects as? [WordLearnt]
                guard let wordsLearnt = words else {return}
                var characterDict = [String: WordLearnt]()

                //counter for confidence to unlock
                var isOk = 0 //green, yellow
                var isSoso = 0 //light orange
                var isNotOk = 0 //red, orange

                for wordLearnt in wordsLearnt {
                    characterDict[wordLearnt.word!] = wordLearnt
                    let confidence = Int(wordLearnt.confidenceCounter)
                    switch confidence {
                    case 4, 3:
                        isOk += 1
                    case 1, 0:
                        isNotOk += 1
                    default:
                        isSoso += 1
                    }
                }

                //unlock next chracters and save
                if !item.unLockNext {
                    if isOk >= 1 && isNotOk == 0 {
                        let backgroundEntity = coreDataStack.privateContext.object(with: item.objectID) as! Consonant
                        backgroundEntity.unLockNext = true
                        unLockNextConsonant[consonant] = true
                        if consonant != "P" && consonant != "Py" {
                            unlockedcellCounter += 1
                        }
                        coreDataStack.saveTo(context: coreDataStack.privateContext)
                        coreDataStack.viewContext.refresh(item, mergeChanges: true)
                    } else {
                        unLockNextConsonant[consonant] = false
                    }
                } else {
                    unLockNextConsonant[consonant] = true
                    if consonant != "P" && consonant != "Py" {
                        unlockedcellCounter += 1
                    }
                }
                consonantAndWordDict[consonant] = characterDict
                consonantDict[consonant] = item
            }
            self.numberOfUnlockedCell = unlockedcellCounter
            //set isUnlocked true
            let willUnlockConsonant = japaneseList[unlockedcellCounter - 1].sound
            let consonant = consonantDict[willUnlockConsonant]!
            let backgroundEntity = coreDataStack.privateContext.object(with: consonant.objectID) as! Consonant
            backgroundEntity.isUnlocked = true
            coreDataStack.saveTo(context: coreDataStack.privateContext)
            coreDataStack.viewContext.refresh(consonant, mergeChanges: true)
        }catch let error {
            print(error)
        }
        collectionView.reloadData()
    }
    
    func scrollToItemIndexPath(menuindex: Int) {
        collectionView.reloadData()
        let indexPath = NSIndexPath(item: 0, section: menuindex)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
    
    func chooseJapaneseCharacterType(type: JapaneseType) {
        // chooses hiragana or katakana based on users' choice
        switch type {
        case .hiragana:
            self.japaneseList = JapaneseCharacters().hiraganaList
        case .katakana:
            self.japaneseList = JapaneseCharacters().katakanaList
        case .yVowelHiragana:
            self.japaneseList = JapaneseCharacters().yVowelHiraganaList
        case .yVowelKatakana:
            self.japaneseList = JapaneseCharacters().yVowelKatakanaList
        }
    }
    
    //delegation function
    func getSelectedValue(selectedJapanese: [String: [String?]], selectedJpaneseCoreData: [String: WordLearnt]) {
        //makes practice button avairable
        if self.selectedJapanese.isEmpty {
            practiceButton.alpha = 1
            practiceButton.isEnabled = true
        }
        self.selectedJapanese = selectedJapanese
        self.selectedJpaneseCoreData = selectedJpaneseCoreData
    }
    
    //delegation function
    func getDeselectedValue(selectedJapanese: [String: [String?]], selectedJpaneseCoreData: [String: WordLearnt]) {
        self.selectedJapanese = selectedJapanese
        self.selectedJpaneseCoreData = selectedJpaneseCoreData
        //if dictionary is empty, makes practice button enable
        if self.selectedJapanese.isEmpty {
            practiceButton.alpha = 0.5
            practiceButton.isEnabled = false
        }
    }
    
    
    @IBAction func practiceButtonTapped(_ sender: Any) {
        if !selectedJapanese.isEmpty {
            let storyboard = UIStoryboard(name: "Speaking", bundle: .main)
            let showCharacterVC = storyboard.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
            showCharacterVC.japaneseList = self.japaneseList
            showCharacterVC.japaneseDict = self.selectedJapanese
            showCharacterVC.japaneseType = self.japaneseType
            showCharacterVC.characterCoreDataDict = self.selectedJpaneseCoreData
            self.selectedJapanese = [:]
            self.selectedJpaneseCoreData = [:]
            self.practiceButton.alpha = 0.5
            self.practiceButton.isEnabled = false
            present(showCharacterVC, animated: true, completion: nil)
        }

    }
    
}

extension JapaneseCharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: consonantViewCell, for: indexPath) as! ConsonantViewCell
            cell.delegate = self
            cell.japaneseList = self.japaneseList
            cell.japaneseType = self.japaneseType
            cell.selectedJapanese = self.selectedJapanese
            cell.selectedJpaneseCoreData = self.selectedJpaneseCoreData
            cell.consonantDict = self.consonantAndWordDict
            cell.numberOfUnlockedCell = self.numberOfUnlockedCell
            cell.collectionView.reloadData()
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: overViewCell, for: indexPath) as! OverViewCell
            cell.delegate = self
            cell.japaneseList = self.japaneseList
            cell.japaneseType = self.japaneseType
            cell.selectedJapanese = self.selectedJapanese
            cell.selectedJpaneseCoreData = self.selectedJpaneseCoreData
            cell.consonantDict = self.consonantAndWordDict
            cell.unLockNextConsonant = self.unLockNextConsonant
            cell.collectionView.reloadData()
            return cell
        }
    }
    
}


