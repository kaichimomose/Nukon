//
//  ConsonantViewCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/03/05.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

protocol GetValueFromCell {
    func selectCharacter(consonant: String, index: Int, character: String, nilList: [String?])
    func deselectCharacter(consonant: String, index: Int, character: String)
}

class ConsonantViewCell: UICollectionViewCell, GetValueFromCell {
    
    //MARK: - Properties
    var delegate: GetValueFromCollectionView?
    
    var japaneseList: [Japanese]!
    var japaneseType: JapaneseType!
    let vowels = JapaneseCharacters().vowelSounds
    
    var selectedJapanese: [String: [String?]]!
    var selectedJpaneseCoreData: [String: WordLearnt]!
    var consonantDict: [String: [String: WordLearnt]]!
    
    var numberOfUnlockedCell: Int!
    
    let cellReuseIdentifer = "FirstCharacterCell"
    
    //collectionView layout
//    let layout = UICollectionViewFlowLayout() //UPCarouselFlowLayout()
//    let inset = UIEdgeInsets(top: 50, left: 10, bottom: 100, right: 10)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "FirstCharacterCell", bundle: .main), forCellWithReuseIdentifier: cellReuseIdentifer)

        collectionView.alwaysBounceVertical = true
        collectionView.isPagingEnabled = true

    }
    
    //delegation function
    func selectCharacter(consonant: String, index: Int, character: String, nilList: [String?]) {
        //if key does not have value, assigns value
        if (self.selectedJapanese[consonant] == nil) {
            self.selectedJapanese[consonant] = nilList
        }
        //assigns character
        self.selectedJapanese[consonant]![index] = character
        self.selectedJpaneseCoreData[character] = consonantDict[consonant]![character]
        delegate?.getSelectedValue(selectedJapanese: self.selectedJapanese, selectedJpaneseCoreData: self.selectedJpaneseCoreData)
    }
    
    //delegation function
    func deselectCharacter(consonant: String, index: Int, character: String) {
        //deletes character from list
        self.selectedJapanese[consonant]![index] = nil
        self.selectedJpaneseCoreData[character] = nil
        //checks a key has a value
        self.checkDictionary(consonant: consonant)
        
        delegate?.getDeselectedValue(selectedJapanese: self.selectedJapanese, selectedJpaneseCoreData: self.selectedJpaneseCoreData)
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
    
}

extension ConsonantViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfUnlockedCell    //japaneseList.count
    }
    
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return ["Vowel", "K", "S"]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let firstCharacterCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifer, for: indexPath) as! FirstCharacterCell
        
        let row = indexPath.row
        firstCharacterCell.characterViews.forEach { view in
            view.alpha = 0
        }
        firstCharacterCell.checkboxesImageViews.forEach { imageView in
            imageView.alpha = 0
        }
        firstCharacterCell.collectionView = self.collectionView
        firstCharacterCell.delegate = self
        firstCharacterCell.characterDict = self.consonantDict[japaneseList[row].sound]
        firstCharacterCell.japanese = self.japaneseList[row]
        firstCharacterCell.selectedJapanese = self.selectedJapanese[self.japaneseList[row].sound]
        
        return firstCharacterCell
    }
}

