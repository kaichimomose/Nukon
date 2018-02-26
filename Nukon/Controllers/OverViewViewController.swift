//
//  OverViewViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/25.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

protocol GetValueFormCell {
    func selectCharacter(consonant: String, index: Int, character: String)
    func deselectCharacter(consonant: String, index: Int)
}

class OverViewViewController: UIViewController, GetValueFormCell {
    
    let selectedType = JapaneseType.katakana
    let japaneseList = JapaneseCharacters().katakanaList
    
    let cellReuseIdentifer = "OverViewCollectionViewCell"
    let layout = UICollectionViewFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var selectedJapanese = [String: [String?]]()
    
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
        
        self.title = selectedType.rawValue
        
        practiceButton.alpha = 0.5
        practiceButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegation function
    func selectCharacter(consonant: String, index: Int, character: String) {
        //makes practice button avairable
        if self.selectedJapanese.isEmpty {
            practiceButton.alpha = 1
            practiceButton.isEnabled = true
        }
        //if key does not have value, assigns value
        if (self.selectedJapanese[consonant] == nil) {
            self.selectedJapanese[consonant] = [nil, nil, nil, nil, nil, nil]
        }
        //assigns character
        self.selectedJapanese[consonant]![index] = character
    }
    
    //delegation function
    func deselectCharacter(consonant: String, index: Int) {
        //deletes character from list
        self.selectedJapanese[consonant]![index] = nil
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
        if nilCount == 6 {
            self.selectedJapanese[consonant] = nil
        }
    }
    
    //MARK: - Actions
    @IBAction func practiceTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Speaking", bundle: .main)
        let showCharacterVC = storyboard.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
        showCharacterVC.japaneseList = self.japaneseList
        showCharacterVC.japaneseDict = self.selectedJapanese
        showCharacterVC.japaneseType = self.selectedType
        self.selectedJapanese = [:]
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
        cell.japanese = self.japaneseList[row]
        cell.selectedJapanese = self.selectedJapanese[self.japaneseList[row].sound] ?? [nil, nil, nil, nil, nil, nil]
        return cell
    }
}
