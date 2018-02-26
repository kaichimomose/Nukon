//
//  JapaneseCharactersCollectionViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/06.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation

class JapaneseCharactersCollectionViewController: UIViewController {
    //MARK: - Properties
    let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    let speak = AVSpeechSynthesizer()
    
    var japaneseList = [Japanese]()
    var selectedType: JapaneseType!
    let vowels = JapaneseCharacters().vowelSounds
    
    var consonant: String!
    var selectedJapanese = [String: [String?]]()
    
    var labels = [UILabel]()
    
    //delegation
    var delegate: CellDelegate?
    
    //collectionView layout
    let layout = UICollectionViewFlowLayout() //UPCarouselFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var parentsStackView: UIStackView!
    @IBOutlet weak var childrenStackView: UIStackView!
    @IBOutlet weak var sixthChidStackView: UIStackView!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var ilabel: UILabel!
    @IBOutlet weak var ulabel: UILabel!
    @IBOutlet weak var elabel: UILabel!
    @IBOutlet weak var olabel: UILabel!
    @IBOutlet weak var nLabel: UILabel!
    
    
    @IBOutlet var soundButtons: [UIButton]!
    @IBOutlet var soundsLabels: [UILabel]!
    @IBOutlet var checkboxes: [UIImageView]!
    
    @IBOutlet weak var practiceButton: UIButton!
    
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets title
        switch self.selectedType {
            case .hiragana, .katakana:
                self.title = "Regular-sounds"
            case .voicedHiragana, .voicedKatakana:
                self.title = "Voiced-sounds"
            case .yVowelHiragana, .yVowelKatakana:
                self.title = "Y-vowel-sounds"
            default:
                self.title = ""
        }
        
        //collectionview setting
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SoundsCell", bundle: .main), forCellWithReuseIdentifier: "SoundsCell")
        collectionView.register(UINib.init(nibName: "FirstCharacterCell", bundle: .main), forCellWithReuseIdentifier: "FirstCharacterCell")
        
        //cell setting
        let length = UIScreen.main.bounds.width - (inset.left+inset.right)
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = inset
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: length, height: length)
        layout.itemSize = CGSize(width: length, height: length)
        
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceHorizontal = true
        
        
        parentsStackView.isHidden = true

        labels = [aLabel, ilabel, ulabel, elabel, olabel, nLabel]
        
        labels.forEach { label in
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 0.5
            label.layer.cornerRadius = 25
            label.layer.masksToBounds = true
        }
        
        practiceButton.alpha = 0.5
        practiceButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.chooseJapaneseCharacterType(type: selectedType)
    }

    func chooseJapaneseCharacterType(type: JapaneseType) {
        // chooses hiragana or katakana based on users' choice
        switch type {
        case .hiragana:
            self.japaneseList = JapaneseCharacters().hiraganaList
        case .katakana:
            self.japaneseList = JapaneseCharacters().katakanaList
        case .voicedHiragana:
            self.japaneseList = JapaneseCharacters().voicedHiraganaList
        case .voicedKatakana:
            self.japaneseList = JapaneseCharacters().voicedKatakanaList
        case .yVowelHiragana:
            self.japaneseList = JapaneseCharacters().yVowelHiraganaList
        case .yVowelKatakana:
            self.japaneseList = JapaneseCharacters().yVowelKatakanaList
        }
    }
    
    func animateView() {
        
        //initial settings
        self.childrenStackView.alpha = 0
        
        self.labels.forEach({ label in
            label.transform = CGAffineTransform(rotationAngle: 90).concatenating(CGAffineTransform(translationX: 0, y: -200))
            label.alpha = 0
        })
        
        self.soundsLabels.forEach { label in
            label.alpha = 0
        }
        
        self.soundButtons.forEach { button in
            button.alpha = 0
            button.isEnabled = false
        }
        
        if let characterList = self.selectedJapanese[self.consonant] {
            for i in 0..<characterList.count {
                if characterList[i] != nil {
                    self.checkboxes[i].image = #imageLiteral(resourceName: "checkedcheckbox")
                } else {
                    self.checkboxes[i].image = #imageLiteral(resourceName: "emptycheckbox")
                }
                self.checkboxes[i].alpha = 0
            }
        } else {
            self.checkboxes.forEach({ imageView in
                imageView.image = #imageLiteral(resourceName: "emptycheckbox")
                imageView.alpha = 0
            })
        }
        
        
        let animations = {
            self.childrenStackView.transform = CGAffineTransform.identity
            self.childrenStackView.alpha = 1
            
            var delay: Double = 0.3
            //aimation for each character label
            for i in 0..<self.labels.count {
                let labelsAnimations = {
                    self.labels[i].transform = CGAffineTransform.identity
                    self.labels[i].alpha = 1
                    self.soundsLabels[i].alpha = 1
                }
            
                UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: labelsAnimations, completion: nil)
                
                //update delay
                delay += 0.5
            }
            
            let buttonAnimation = {
                self.soundButtons.forEach({ button in
                    button.alpha = 1
                    button.isEnabled = true
                })
                
                self.checkboxes.forEach({ imageView in
                    imageView.alpha = 1
                })
            }
            //sound button and check box appear in the end of animation
            UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: buttonAnimation, completion: nil)
            
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: animations, completion: nil)
    }
    
    //speaks japanese
    func speakJapanese(string: String) {
        let textToSpeak = AVSpeechUtterance(string: string)
        textToSpeak.rate = 0.3
        textToSpeak.volume = 1.0
        //        let numberOfSeconds = 10.0
        //        textToSpeak.preUtteranceDelay = numberOfSeconds
        textToSpeak.voice = speakerVoice
        //        speak.delegate = self
        speak.speak(textToSpeak)
    }
    
    //speak japanese characters orderly
    var index: Int = 0
    func speakOrderly(list: [String]) {
        if index < list.count {
            speakJapanese(string: list[index])
            //delay 0.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.index += 1
                self.speakOrderly(list: list)
            })
        } else {
            //user can use collection view after specking finish
            index = 0
            collectionView.isUserInteractionEnabled = true
            return
        }
    }
    
    func checkUncheckBox(index: Int) {
        let imageView: UIImageView = self.checkboxes[index]
        let label: UILabel = self.labels[index]
        if imageView.image == #imageLiteral(resourceName: "checkedcheckbox") {
            imageView.image = #imageLiteral(resourceName: "emptycheckbox")
            //flashing delegation task
            self.delegate?.stopFlashingAnimation(Index: index)
            //deletes character from list
            self.selectedJapanese[self.consonant]![index] = nil
            //checks a key has a value
            self.checkDictionary()
            //if dictionary is empty, makes practice button enable
            if self.selectedJapanese.isEmpty {
                practiceButton.alpha = 0.5
                practiceButton.isEnabled = false
            }
        } else {
            imageView.image = #imageLiteral(resourceName: "checkedcheckbox")
            self.delegate?.flashingAnimation(Index: index)
            //makes practice button avairable
            if self.selectedJapanese.isEmpty {
                practiceButton.alpha = 1
                practiceButton.isEnabled = true
            }
            //if key does not have value, assigns value
            if (self.selectedJapanese[self.consonant] == nil) {
                self.selectedJapanese[self.consonant] = [nil, nil, nil, nil, nil, nil]
            }
            //assigns character
            self.selectedJapanese[self.consonant]![index] = label.text!
        }
    }
    
    func checkDictionary() {
        var nilCount = 0
        for character in self.selectedJapanese[self.consonant]! {
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
            self.selectedJapanese[self.consonant] = nil
        }
    }
    
    //MARK: - TapGesture Action
    @IBAction func firstChracterTapped(_ sender: Any) {
        checkUncheckBox(index: 0)
    }
    
    @IBAction func secondCharacterTapped(_ sender: Any) {
        checkUncheckBox(index: 1)
    }
    
    @IBAction func thirdChracterTapped(_ sender: Any) {
        checkUncheckBox(index: 2)
    }
    
    @IBAction func fourthChracterTapped(_ sender: Any) {
        checkUncheckBox(index: 3)
    }
    
    @IBAction func fifthChracterTapped(_ sender: Any) {
        checkUncheckBox(index: 4)
    }
    
    @IBAction func sixthChracterTapped(_ sender: Any) {
        checkUncheckBox(index: 5)
    }
    
    //MARK: - Sound Button Action
    @IBAction func aLabelSoundTappped(_ sender: Any) {
        let character = aLabel.text
        speakJapanese(string: character!)
    }
    
    @IBAction func iLabelSoundTappped(_ sender: Any) {
        let character = ilabel.text
        speakJapanese(string: character!)
    }
    @IBAction func uLabelSoundTappped(_ sender: Any) {
        let character = ulabel.text
        speakJapanese(string: character!)
    }
    @IBAction func eLabelSoundTappped(_ sender: Any) {
        let character = elabel.text
        speakJapanese(string: character!)
    }
    @IBAction func oLabelSoundTappped(_ sender: Any) {
        let character = olabel.text
        speakJapanese(string: character!)
    }
    @IBAction func nLabelSoundTappped(_ sender: Any) {
        let character = nLabel.text
        speakJapanese(string: character!)
    }
    
    //MARK: - Exit Button Action
    @IBAction func exitTapped(_ sender: Any) {
        collectionView.collectionViewLayout.invalidateLayout()
        parentsStackView.isHidden = true
        for stackView in childrenStackView.arrangedSubviews {
            stackView.isHidden = false
        }
    }
    
    @IBAction func practiceButtonTapped(_ sender: Any) {
        print(selectedJapanese)
        if !selectedJapanese.isEmpty {
            let storyboard = UIStoryboard(name: "Speaking", bundle: .main)
            let showCharacterVC = storyboard.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
            showCharacterVC.japaneseList = self.japaneseList
            showCharacterVC.japaneseDict = self.selectedJapanese
            showCharacterVC.japaneseType = self.selectedType
            self.selectedJapanese = [:]
            parentsStackView.isHidden = true
            present(showCharacterVC, animated: true, completion: nil)
        }
        
    }
    
}

extension JapaneseCharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return japaneseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let firstCharacterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCharacterCell", for: indexPath) as! FirstCharacterCell
        
        let row = indexPath.row
        
        firstCharacterCell.layer.cornerRadius = 5
        firstCharacterCell.characterLabel.text = japaneseList[row].sound
        
        let characterList = japaneseList[row].letters
        
        for i in 0..<characterList.count {
            firstCharacterCell.characterLabels[i].text = nil
            firstCharacterCell.characterLabels[i].alpha = 1
            if characterList[i] != "　" {
                firstCharacterCell.characterLabels[i].text = characterList[i]
            }
            else {
                firstCharacterCell.characterLabels[i].alpha = 0
            }
            
        }
        
        return firstCharacterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let characterList = japaneseList[row].letters
        let consonant = japaneseList[row].sound
        
        self.consonant = consonant
        
        for stackView in childrenStackView.arrangedSubviews {
            stackView.isHidden = false
        }
        
        for i in 0..<characterList.count {
            labels[i].text = nil
            if characterList[i] != "　" {
                labels[i].text = characterList[i]
                if consonant != "vowel" {
                    soundsLabels[i].text = consonant.lowercased() + vowels[i]
                } else {
                    soundsLabels[i].text = vowels[i]
                }
            } else {
                childrenStackView.arrangedSubviews[i+1].isHidden = true
            }
        }

        parentsStackView.isHidden = false
        
        collectionView.isUserInteractionEnabled = false
        
        //gets selected cell instance
        let cell = collectionView.cellForItem(at: indexPath) as! FirstCharacterCell
        cell.japaneseCharactersCVC = self
        
        //starts animation
        animateView()
        
        //starts speaking voice
        speakOrderly(list: characterList)
    }
    
}


