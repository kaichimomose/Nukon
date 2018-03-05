//
//  JapaneseCharactersCollectionViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/06.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class JapaneseCharactersCollectionViewController: UIViewController, GetValueFromCell {
    //MARK: - Properties
    let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    let speak = AVSpeechSynthesizer()
    
    var japaneseList = [Japanese]()
    var japaneseType: JapaneseType!
    let vowels = JapaneseCharacters().vowelSounds
    
    var selectedJapanese = [String: [String?]]()
    var selectedJpaneseCoreData = [String: WordLearnt]()
    var consonantDict = [String: [String: WordLearnt]]()
    
    var unLockNextConsonant = [String: Bool]()
    var numberOfUnlockedCell: Int = 1
    
    var labels = [UILabel]()
    
    let coreDataStack = CoreDataStack.instance
    
    //delegation
    var delegate: CellDelegate?
    
    //collectionView layout
    let layout = UICollectionViewFlowLayout() //UPCarouselFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var practiceButton: UIButton!
    
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    
    @IBOutlet weak var menuBar: MenuBar!
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets title
        switch self.japaneseType {
            case .hiragana, .katakana:
                self.title = "Regular-sounds"
            case .yVowelHiragana, .yVowelKatakana:
                self.title = "Y-vowel-sounds"
            default:
                self.title = ""
        }
        
        menuBarCollectionView.delegate = menuBar
        menuBarCollectionView.dataSource = menuBar
        
        let selectedIndexpath = NSIndexPath(row: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexpath as IndexPath, animated: false, scrollPosition: [])
        
        //collectionview setting
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SoundsCell", bundle: .main), forCellWithReuseIdentifier: "SoundsCell")
        collectionView.register(UINib.init(nibName: "FirstCharacterCell", bundle: .main), forCellWithReuseIdentifier: "FirstCharacterCell")
        
        //cell setting
        let length = UIScreen.main.bounds.width - (inset.left+inset.right)
        
        layout.scrollDirection = .vertical
        layout.sectionInset = inset
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: length, height: length)
        layout.itemSize = CGSize(width: length, height: length)
        
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceVertical = true
        
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
                        coreDataStack.saveTo(context: coreDataStack.privateContext)
                        coreDataStack.viewContext.refresh(item, mergeChanges: true)
                    } else {
                        unLockNextConsonant[consonant] = false
                    }
                } else {
                    unLockNextConsonant[consonant] = true
                    if consonant != "P" && consonant != "Py" {
                        numberOfUnlockedCell += 1
                    }
                }
                
                consonantDict[consonant] = characterDict
            }
        }catch let error {
            print(error)
        }
        collectionView.reloadData()
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
    func selectCharacter(consonant: String, index: Int, character: String, nilList: [String?]) {
        //makes practice button avairable
        if self.selectedJapanese.isEmpty {
            practiceButton.alpha = 1
            practiceButton.isEnabled = true
        }
        //if key does not have value, assigns value
        if (self.selectedJapanese[consonant] == nil) {
            self.selectedJapanese[consonant] = nilList
        }
        //assigns character
        self.selectedJapanese[consonant]![index] = character
        self.selectedJpaneseCoreData[character] = consonantDict[consonant]![character]
    }
    
    //delegation function
    func deselectCharacter(consonant: String, index: Int, character: String) {
        //deletes character from list
        self.selectedJapanese[consonant]![index] = nil
        self.selectedJpaneseCoreData[character] = nil
        //checks a key has a value
        self.checkDictionary(consonant: consonant)
        //if dictionary is empty, makes practice button enable
        if self.selectedJapanese.isEmpty {
            practiceButton.alpha = 0.5
            practiceButton.isEnabled = false
        }
    }
    
    func checkDictionary(consonant: String) {
        var nilCount = 0
        let numberOfContents = self.selectedJapanese[consonant]!.count
        for character in self.selectedJapanese[consonant]! {
            //if a key has a value, return
            if character != nil {
                return
            } else {
                //increment nil number
                nilCount += 1
            }
        }
        //all values are nil, delete key from ditionary
        if nilCount == numberOfContents {
            self.selectedJapanese[consonant] = nil
        }
    }
    
    @IBAction func practiceButtonTapped(_ sender: Any) {
        print(selectedJapanese)
        if !selectedJapanese.isEmpty {
            let storyboard = UIStoryboard(name: "Speaking", bundle: .main)
            let showCharacterVC = storyboard.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
            showCharacterVC.japaneseList = self.japaneseList
            showCharacterVC.japaneseDict = self.selectedJapanese
            showCharacterVC.japaneseType = self.japaneseType
            showCharacterVC.characterCoreDataDict = self.selectedJpaneseCoreData
            self.selectedJapanese = [:]
            self.selectedJpaneseCoreData = [:]
            present(showCharacterVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func overviewTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "OverView", bundle: .main)
        let overViewVC = storyboard.instantiateViewController(withIdentifier: "OverViewViewController") as! OverViewViewController
        overViewVC.japaneseType = self.japaneseType
        overViewVC.japaneseList = self.japaneseList
        present(overViewVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OverView" {
            let overViewVC = segue.destination as! OverViewViewController
            overViewVC.japaneseType = self.japaneseType
            overViewVC.japaneseList = self.japaneseList
        }
    }
    
}

extension JapaneseCharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfUnlockedCell//japaneseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let firstCharacterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCharacterCell", for: indexPath) as! FirstCharacterCell
        
        let row = indexPath.row
        firstCharacterCell.collectionView = self.collectionView
        firstCharacterCell.delegate = self
        firstCharacterCell.characterDict = self.consonantDict[japaneseList[row].sound]
        firstCharacterCell.japanese = japaneseList[row]
        
        return firstCharacterCell
    }
    
}


