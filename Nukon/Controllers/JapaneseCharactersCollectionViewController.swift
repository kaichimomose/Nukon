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

    let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    let speak = AVSpeechSynthesizer()
    
    var japaneseList = [Japanese]()
    var selectedType: JapaneseType!
    let vowels = JapaneseCharacters().vowelSounds
    
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
    
    
    
    var labels = [UILabel]()
    @IBOutlet var soundButtons: [UIButton]!
    @IBOutlet var soundsLabels: [UILabel]!
    @IBOutlet var checkboxes: [UIImageView]!
    
    let layout = UICollectionViewFlowLayout() //UPCarouselFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SoundsCell", bundle: .main), forCellWithReuseIdentifier: "SoundsCell")
        collectionView.register(UINib.init(nibName: "FirstCharacterCell", bundle: .main), forCellWithReuseIdentifier: "FirstCharacterCell")

        let length = UIScreen.main.bounds.width - (inset.left+inset.right)
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func exitTapped(_ sender: Any) {
        collectionView.collectionViewLayout.invalidateLayout()
        parentsStackView.isHidden = true
        for stackView in childrenStackView.arrangedSubviews {
            stackView.isHidden = false
        }
    }
    
    func animateView() {

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
        
        
        let animations = {
//            self.childrenStackView.axis = .horizontal
            
            self.childrenStackView.transform = CGAffineTransform.identity
            self.childrenStackView.alpha = 1
            
            var delay: Double = 0.3
            
            for i in 0..<self.labels.count {
                
                let labelsAnimations = {
                    self.labels[i].transform = CGAffineTransform.identity
                    self.labels[i].alpha = 1
                    self.soundsLabels[i].alpha = 1
                }
            
                UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: labelsAnimations, completion: nil)
                
                delay += 0.5
            }
            
            let buttonAnimation = {
                self.soundButtons.forEach({ button in
                    button.alpha = 1
                    button.isEnabled = true
                })
            }
            
            UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: buttonAnimation, completion: nil)
            
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: animations, completion: nil)
    }
    
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
    
    var index: Int = 0
    func speakOrderly(list: [String]) {
        if index < list.count {
            speakJapanese(string: list[index])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.index += 1
                self.speakOrderly(list: list)
            })
        } else {
            index = 0
            collectionView.isUserInteractionEnabled = true
            return
        }
    }
    
    @IBAction func aLabelSoundTappped(_ sender: Any) {
        let character = aLabel.text
        speakJapanese(string: character!)
    }
    
    @IBAction func firstChracterTapped(_ sender: Any) {
        checkUncheckBox(imageView: checkboxes[0])
    }
    
    @IBAction func secondCharacterTapped(_ sender: Any) {
        checkUncheckBox(imageView: checkboxes[1])
    }
    
    @IBAction func thirdChracterTapped(_ sender: Any) {
        checkUncheckBox(imageView: checkboxes[2])
    }
    
    @IBAction func fourthChracterTapped(_ sender: Any) {
        checkUncheckBox(imageView: checkboxes[3])
    }
    
    @IBAction func fifthChracterTapped(_ sender: Any) {
        checkUncheckBox(imageView: checkboxes[4])
    }
    
    @IBAction func sixthChracterTapped(_ sender: Any) {
        checkUncheckBox(imageView: checkboxes[5])
    }
    
    
    
    func checkUncheckBox(imageView: UIImageView) {
        if imageView.image == #imageLiteral(resourceName: "checkedcheckbox") {
            imageView.image = #imageLiteral(resourceName: "emptycheckbox")
        } else {
            imageView.image = #imageLiteral(resourceName: "checkedcheckbox")
        }
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
        
        return firstCharacterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let characterList = japaneseList[row].letters
        let consonant = japaneseList[row].sound.lowercased()
        
        for stackView in childrenStackView.arrangedSubviews {
            stackView.isHidden = false
        }
        
        for i in 0..<characterList.count {
            labels[i].text = nil
            if characterList[i] != "　" {
                labels[i].text = characterList[i]
                if consonant != "vowel" {
                    soundsLabels[i].text = consonant + vowels[i]
                } else {
                    soundsLabels[i].text = vowels[i]
                }
            } else {
                childrenStackView.arrangedSubviews[i+1].isHidden = true
            }
        }

        parentsStackView.isHidden = false
        
        collectionView.isUserInteractionEnabled = false
        
        animateView()
        
        speakOrderly(list: characterList)
    }
    
}


