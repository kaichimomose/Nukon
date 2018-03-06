//
//  FirstCharacterCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/07.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation

protocol CellDelegate {
    func flashingAnimation(Index: Int)
    func stopFlashingAnimation(Index: Int)
}

class FirstCharacterCell: UICollectionViewCell {
    
    //MARK: - Propaties
    let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    let speak = AVSpeechSynthesizer()
    
    var collectionView: UICollectionView!
    var delegate: GetValueFromCell?
    
    let vowels = JapaneseCharacters().vowelSounds
    var characterDict: [String: WordLearnt]!
    
    
    var japanese: Japanese! {
        didSet {
            characterLabel.text = japanese.sound
            let numberOfCharacters = japanese.letters.count
            switch numberOfCharacters {
            case 3:
                for i in 0..<japanese.letters.count {
                    let apperIndex = i*2
                    let character = japanese.letters[i]
                    characterLabels[apperIndex].text = character
                    self.coloringAndUnlock(character: character, index: apperIndex)
                    soundLabels[apperIndex].text = japanese.sound.lowercased() + vowels[apperIndex]
                    if i < 2 {
                        let hideIndex = apperIndex + 1
                        characterViews[hideIndex].backgroundColor = .clear
                        checkboxesImageViews[hideIndex].isHidden = true
                        characterLabels[hideIndex].alpha = 0
                        soundLabels[hideIndex].isHidden = true
                    }
                }
            case 2:
                for i in 0..<japanese.letters.count {
                    let apperIndex = i*4
                    let character = japanese.letters[i]
                    characterLabels[apperIndex].text = character
                    self.coloringAndUnlock(character: character, index: apperIndex)
                    soundLabels[apperIndex].text = japanese.sound.lowercased() + vowels[apperIndex]
                }
                for j in 1...3 {
                    characterViews[j].backgroundColor = .clear
                    checkboxesImageViews[j].isHidden = true
                    characterLabels[j].alpha = 0
                    soundLabels[j].isHidden = true
                }
            case 1:
                let character = japanese.letters[0]
                self.coloringAndUnlock(character: character, index: 2)
                characterLabels[2].text = character
                soundLabels[2].text = "n"
                for i in 0..<5 {
                    if i != 2 {
                        characterViews[i].backgroundColor = .clear
                        checkboxesImageViews[i].isHidden = true
                        characterLabels[i].alpha = 0
                        soundLabels[i].isHidden = true
                    }
                }
            default:
                for i in 0..<japanese.letters.count {
                    let character = japanese.letters[i]
                    self.coloringAndUnlock(character: character, index: i)
                    checkboxesImageViews[i].isHidden = false
                    characterLabels[i].alpha = 1
                    soundLabels[i].isHidden = false
                    characterLabels[i].text = character
                    if japanese.sound == "Vowel" {
                        soundLabels[i].text = vowels[i]
                    } else {
                        soundLabels[i].text = japanese.sound.lowercased() + vowels[i]
                    }
                }
            }
        }
    }
    
    var selectedJapanese: [String?]? {
        didSet {
            guard let selectedJapanese = self.selectedJapanese else {
                self.checkboxesImageViews.forEach({ imageView in
                    imageView.image = #imageLiteral(resourceName: "emptycheckbox")
                })
                return
            }
            let numberOfCharacters = japanese.letters.count
            switch numberOfCharacters {
            case 3:
                for i in 0..<selectedJapanese.count {
                    let apperIndex = i*2
                    if selectedJapanese[i] != nil {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "checkedcheckbox")
                    } else {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "emptycheckbox")
                    }
                }
            case 2:
                for i in 0..<selectedJapanese.count {
                    let apperIndex = i*4
                    if selectedJapanese[i] != nil {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "checkedcheckbox")
                    } else {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "emptycheckbox")
                    }
                }
            case 1:
                if selectedJapanese[0] != nil {
                    checkboxesImageViews[2].image = #imageLiteral(resourceName: "checkedcheckbox")
                } else {
                    checkboxesImageViews[2].image = #imageLiteral(resourceName: "emptycheckbox")
                }
            default:
                for i in 0..<selectedJapanese.count {
                    if selectedJapanese[i] != nil {
                        checkboxesImageViews[i].image = #imageLiteral(resourceName: "checkedcheckbox")
                    } else {
                        checkboxesImageViews[i].image = #imageLiteral(resourceName: "emptycheckbox")
                    }
                }
            }
        }
    }
    
    var checkboxesImageViews: [UIImageView]!
    
    var characterLabels: [UILabel]!
    var soundLabels: [UILabel]!
    
    //MARK: - Outlets
    @IBOutlet weak var characterLabel: UILabel!
    
    @IBOutlet var characterViews: [UIView]!
    
    @IBOutlet weak var aCheckboxImageView: UIImageView!
    @IBOutlet weak var iCheckboxImageView: UIImageView!
    @IBOutlet weak var uCheckboxImageView: UIImageView!
    @IBOutlet weak var eCheckboxImageView: UIImageView!
    @IBOutlet weak var oCheckboxImageView: UIImageView!
    
    @IBOutlet weak var aVowelCharacter: UILabel!
    @IBOutlet weak var iVowelCharacter: UILabel!
    @IBOutlet weak var uVowelCharacter: UILabel!
    @IBOutlet weak var eVowelCharacter: UILabel!
    @IBOutlet weak var oVowelCharacter: UILabel!
    
    @IBOutlet weak var aVowelSound: UILabel!
    @IBOutlet weak var iVowelSound: UILabel!
    @IBOutlet weak var uVowelSound: UILabel!
    @IBOutlet weak var eVowelSound: UILabel!
    @IBOutlet weak var oVowelSound: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        characterLabel.layer.cornerRadius = characterLabel.frame.width/2
        characterLabel.layer.masksToBounds = true
        
        characterViews.forEach { view in
            view.layer.cornerRadius = view.frame.height/2
            view.alpha = 0
        }
        
        buttons.forEach { button in
            button.isEnabled = false
        }
        
        checkboxesImageViews = [aCheckboxImageView, iCheckboxImageView, uCheckboxImageView, eCheckboxImageView, oCheckboxImageView]
        
        checkboxesImageViews.forEach { imageView in
            imageView.backgroundColor = .white
            imageView.layer.cornerRadius = imageView.frame.size.height/2
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.masksToBounds = true
            imageView.alpha = 0
        }
        
        characterLabels = [aVowelCharacter, iVowelCharacter, uVowelCharacter, eVowelCharacter, oVowelCharacter]
        
        soundLabels = [aVowelSound, iVowelSound, uVowelSound, eVowelSound, oVowelSound]
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
//        
////        let height = systemLayoutSizeFitting(attributes.size).height
//        
//        attributes.size.height = UIScreen.main.bounds.width - 100
//        attributes.size.width = UIScreen.main.bounds.width - 100
//        //        attributes.size.width = self.contentView.frame.size.width
//        return attributes
//    }
    
    func coloringAndUnlock(character: String, index: Int) {
        if let wordLearnt = characterDict[character] {
            switch wordLearnt.confidenceCounter {
            case 4:
                characterViews[index].backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0) //Green
            case 3:
                characterViews[index].backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0) //Yellow
            case 2:
                characterViews[index].backgroundColor = UIColor(red: 255/255, green: 185/255, blue: 0/255, alpha: 1.0) //Light Orange
            case 1:
                characterViews[index].backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 0/255, alpha: 1.0) //Orange
            default:
                characterViews[index].backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0) //Red
            }
        }
    }
    
    func checkUncheckBox(index: Int) {
        let numberOfCharacters = japanese.letters.count
        let imageView: UIImageView = self.checkboxesImageViews[index]
        let character: String = self.characterLabels[index].text!
        if character != "" {
            var sendIndex: Int!
            var nilList: [String?]!
            switch numberOfCharacters {
            case 3:
                sendIndex = Int(index/2)
                nilList = [nil, nil, nil]
            case 2:
                sendIndex = Int(index/4)
                nilList = [nil, nil]
            case 1:
                sendIndex = 0
                nilList = [nil]
            default:
                sendIndex = index
                nilList = [nil, nil, nil, nil, nil]
            }
            if imageView.image == #imageLiteral(resourceName: "checkedcheckbox") {
                imageView.image = #imageLiteral(resourceName: "emptycheckbox")
                self.delegate?.deselectCharacter(consonant: japanese.sound, index: sendIndex, character: character)
            } else {
                imageView.image = #imageLiteral(resourceName: "checkedcheckbox")
                self.delegate?.selectCharacter(consonant: japanese.sound, index: sendIndex, character: character, nilList: nilList)
            }
        }
    }
    
    func characterDistributingAnimation() {
        //initial settings
        
        self.characterViews.forEach({ view in
            view.transform = CGAffineTransform(rotationAngle: 90).concatenating(CGAffineTransform(translationX: 0, y: 0))
            view.alpha = 0
        })
        
        self.checkboxesImageViews.forEach { imageView in
            imageView.alpha = 0
        }

        self.buttons.forEach { button in
            button.isEnabled = false
        }
        
        let animations = {
            var delay: Double = 0.3
            //aimation for each character label
            for i in 0..<self.characterViews.count {
                let characterViewsAnimations = {
                    self.characterViews[i].transform = CGAffineTransform.identity
                    self.characterViews[i].alpha = 1
                }
                
                UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: characterViewsAnimations, completion: nil)
                
                //update delay
                delay += 0.5
            }
            
            let buttonAnimation = {
                self.buttons.forEach({ button in
                    button.isEnabled = true
                })
                
                self.checkboxesImageViews.forEach({ imageView in
                    imageView.alpha = 1
                })
            }
            //sound button and check box appear in the end of animation
            UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: buttonAnimation, completion: nil)
            
            self.layoutIfNeeded()
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
    
//    func flashingAnimation(Index: Int) {
//        self.characterLabels[Index].alpha = 0.3
//
//        let flashing = {
//            self.characterLabels[Index].alpha = 1
//        }
//
//        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .curveEaseInOut], animations: flashing, completion: nil)
//    }
//
//    func stopFlashingAnimation(Index: Int) {
//        self.characterLabels[Index].layer.removeAllAnimations()
//    }
    
    //MARK: - Actions
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

    @IBAction func consonantTapped(_ sender: Any) {
        collectionView.isUserInteractionEnabled = false
        characterDistributingAnimation()
        speakOrderly(list: japanese.letters)
    }
    
    
}
