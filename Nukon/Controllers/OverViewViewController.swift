//
//  OverViewViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/25.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import CoreData.NSFetchedResultsController

protocol GetValueFromCell {
    func selectCharacter(consonant: String, index: Int, character: String, nilList: [String?])
    func deselectCharacter(consonant: String, index: Int, character: String)
}

class OverViewViewController: UIViewController, GetValueFromCell {
    
    
    //MARK: - Properties
    var japaneseType: JapaneseType!
    var japaneseList: [Japanese]!
    
    let cellReuseIdentifer = "OverViewCollectionViewCell"
    let layout = UICollectionViewFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var selectedJapanese = [String: [String?]]()
    var selectedJpaneseCoreData = [String: WordLearnt]()
    var consonantDict = [String: [String: WordLearnt]]()
    
    var unLockNextConsonant = [String: Bool]()
    
    let coreDataStack = CoreDataStack.instance
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var practiceButton: UIButton!
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: "OverViewCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: cellReuseIdentifer)
        
        let width = UIScreen.main.bounds.width - (inset.left+inset.right)
        let height: CGFloat = 130
        
        layout.scrollDirection = .vertical
        layout.sectionInset = inset
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: width, height: height)
        layout.itemSize = CGSize(width: width, height: height)
        
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceVertical = true
        
        self.title = japaneseType.rawValue
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        practiceButton.alpha = 0.5
        practiceButton.isEnabled = false
        
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
                }
                
                consonantDict[consonant] = characterDict
            }
        }catch let error {
            print(error)
        }
        collectionView.reloadData()
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
    
    //MARK: - Actions
    @IBAction func practiceTapped(_ sender: Any) {
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

extension OverViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.japaneseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifer, for: indexPath) as! OverViewCollectionViewCell
        let row = indexPath.row
        cell.delegate = self
        if row == 0 {
            cell.isUnLocked = true
        } else {
            cell.isUnLocked = self.unLockNextConsonant[self.japaneseList[row-1].sound]
        }
        cell.characterDict = self.consonantDict[self.japaneseList[row].sound]
        cell.japanese = self.japaneseList[row]
        cell.selectedJapanese = self.selectedJapanese[self.japaneseList[row].sound]
        return cell
    }
}
