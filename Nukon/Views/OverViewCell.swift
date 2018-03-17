//
//  OverViewCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/03/05.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class OverViewCell: UICollectionViewCell, GetValueFromCell {
    func scrollToItemIndexPath(index: Int) {
        
    }
    
    
    //MARK: - Properties
    var delegate: GetValueFromCollectionView?
    
    var japaneseList: [Japanese]!
    var japaneseType: JapaneseType!
    let vowels = JapaneseCharacters().vowelSounds
    
    var selectedJapanese: [String: [String?]]!
    var selectedJpaneseCoreData: [String: WordLearnt]!
    var consonantDict: [String: [String: WordLearnt]]!
    
    var unLockNextConsonant: [String: Bool]!
    
    let cellReuseIdentifer = "OverViewCollectionViewCell"
    
    //collectionView layout
    let layout = UICollectionViewFlowLayout() //UPCarouselFlowLayout()
    let inset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "OverViewCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: cellReuseIdentifer)

        //cell setting
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

extension OverViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
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
