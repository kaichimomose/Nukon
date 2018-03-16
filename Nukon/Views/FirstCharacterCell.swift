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
    
    //MARK: - LAYERS
    var pulseLayer: CAShapeLayer!
    
    //MARK: - Propaties
    let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    let speak = AVSpeechSynthesizer()
    
    var collectionView: UICollectionView!
    var delegate: GetValueFromCell?
    
    let vowels = JapaneseCharacters().vowelSounds
    var characterDict: [String: WordLearnt]!
    
    
    var japanese: Japanese! {
        didSet {
            if japanese.sound == "Vowel" || japanese.sound == "Special-N" {
                characterLabel.font = characterLabel.font.withSize(40)
            } else {
                characterLabel.font = characterLabel.font.withSize(100)
            }
            characterLabel.text = japanese.sound
            let numberOfCharacters = japanese.letters.count
            var hiddenIndexes = [Int]()
            for i in 0..<numberOfCharacters {
                let character = japanese.letters[i]
                var vowel: String!
                var apperIndex: Int!
                switch numberOfCharacters {
                    case 3:
                        vowel = vowels[i*2]
                        if i == 0 {
                            apperIndex = 0
                            hiddenIndexes.append(1)
                        }
                        else if i == 1 {
                            apperIndex = 2
                        }
                        else if i == 2 {
                            apperIndex = 3
                            hiddenIndexes.append(4)
                        }
                    case 2:
                        vowel = vowels[i*4]
                        if i == 0 {
                            apperIndex = 1
                            hiddenIndexes.append(0)
                        }
                        if i == 1 {
                            apperIndex = 4
                            hiddenIndexes.append(2)
                            hiddenIndexes.append(3)
                    }
                    case 1:
                        self.coloringAndUnlock(character: character, index: 0)
                        characterLabels[0].text = character
                        soundLabels[0].text = "n"
                        hiddenIndexes = [1, 2, 3, 4]
                    default:
                        vowel = vowels[i]
                        apperIndex = i
                }
                if numberOfCharacters > 1 {
                    checkboxesImageViews[apperIndex].isHidden = false
                    characterLabels[apperIndex].alpha = 1
                    soundLabels[apperIndex].alpha = 1
                    characterLabels[apperIndex].text = character
                    self.coloringAndUnlock(character: character, index: apperIndex)
                    if japanese.sound == "Vowel" {
                        soundLabels[apperIndex].text = vowel
                    } else {
                        soundLabels[apperIndex].text = japanese.sound.lowercased() + vowel
                    }
                }
            }
            for hiddenIndex in hiddenIndexes {
                characterViews[hiddenIndex].backgroundColor = .clear
                checkboxesImageViews[hiddenIndex].isHidden = true
                characterLabels[hiddenIndex].alpha = 0
                soundLabels[hiddenIndex].alpha = 0
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
            print(selectedJapanese)
            let numberOfCharacters = japanese.letters.count
            switch numberOfCharacters {
            case 3:
                for i in 0..<selectedJapanese.count {
                    let apperIndex: Int!
                    if i < 2 {
                        apperIndex = i*2
                    } else {
                        apperIndex = 3
                    }
                    if selectedJapanese[i] != nil {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "checkedcheckbox")
                    } else {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "emptycheckbox")
                    }
                }
            case 2:
                for i in 0..<selectedJapanese.count {
                    let apperIndex: Int!
                    if i == 0 {
                        apperIndex = 1
                    } else {
                        apperIndex = 4
                    }
                    if selectedJapanese[i] != nil {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "checkedcheckbox")
                    } else {
                        checkboxesImageViews[apperIndex].image = #imageLiteral(resourceName: "emptycheckbox")
                    }
                }
            case 1:
                if selectedJapanese[0] != nil {
                    checkboxesImageViews[0].image = #imageLiteral(resourceName: "checkedcheckbox")
                } else {
                    checkboxesImageViews[0].image = #imageLiteral(resourceName: "emptycheckbox")
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
    
    var characterViews: [UIView]!
    
    //MARK: - Outlets
    @IBOutlet weak var characterLabel: UILabel!
    
    @IBOutlet weak var aVowelView: UIView!
    @IBOutlet weak var iVowelView: UIView!
    @IBOutlet weak var uVowelView: UIView!
    @IBOutlet weak var eVowelView: UIView!
    @IBOutlet weak var oVowelView: UIView!
    
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
    
    @IBOutlet weak var upwardsArrow: UILabel!
    @IBOutlet weak var downwardsArrow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        characterLabel.layer.cornerRadius = characterLabel.frame.width/2
        characterLabel.layer.masksToBounds = true
        
        //create pulse layer for when user touches button
        createPulseLayer()
        
        characterViews = [aVowelView, iVowelView, uVowelView, eVowelView, oVowelView]
        
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
    
    func coloringAndUnlock(character: String, index: Int) {
        if let wordLearnt = characterDict[character] {
            switch wordLearnt.confidenceCounter {
            case 4:
                characterViews[index].backgroundColor = UIColor.materialGreen //Green
            case 3:
                characterViews[index].backgroundColor = UIColor.materialLightGreen //LightGreen
            case 2:
                characterViews[index].backgroundColor = UIColor.materialYellow //melon
            case 1:
                characterViews[index].backgroundColor = UIColor.materialOrange //Orange
            default:
                characterViews[index].backgroundColor = UIColor.redSun //Red
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
                if index < 3 {
                    sendIndex = Int(index/2)
                } else {
                    sendIndex = 2
                }
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
        
        for index in 0..<self.characterViews.count {
            let view = self.characterViews[index]
            view.alpha = 0
            
            switch index {
            case 0:
                view.transform = CGAffineTransform.init(translationX: 0, y: 110)
            case 1:
                view.transform = CGAffineTransform.init(translationX: 110, y: 0)
            
            case 2:
                view.transform = CGAffineTransform.init(translationX: 50, y: -110)
                
            case 3:
                view.transform = CGAffineTransform.init(translationX: -50, y: -110)
            
            case 4:
                view.transform = CGAffineTransform.init(translationX: -110, y: 0)
            default:
                view.transform = CGAffineTransform.init(translationX: 0, y: 0)
            }
        }
        
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

    //middle character button is tapped -----------------------------------
    @IBAction func consonantTapped(_ sender: Any) {
        animatePulseLayer()
        collectionView.isUserInteractionEnabled = false
        characterDistributingAnimation()
        speakOrderly(list: japanese.letters)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
        attributes.size.height = collectionView.frame.height
        attributes.size.width = collectionView.frame.width
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }
}


extension FirstCharacterCell {
    
    
    private func createPulseLayer() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 0.2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulseLayer = CAShapeLayer()
        pulseLayer.path = circularPath.cgPath
        pulseLayer.strokeColor = UIColor.clear.cgColor
        pulseLayer.lineWidth = 10
        pulseLayer.fillColor = UIColor.redSun.cgColor
        pulseLayer.lineCap = kCALineCapRound
        pulseLayer.position = characterLabel.center
        characterLabel.layer.addSublayer(pulseLayer)
    }
    
    //Pulsating animations
    func animatePulseLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        
        //initial values
        animation.toValue = 960
        fadeAnimation.fromValue = 1
        
        //how long animation runs
        animation.duration = 0.4
        fadeAnimation.duration = 0.45
        
        //ending values of animations
        fadeAnimation.toValue = 0
        
        //animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsating")
        pulseLayer.add(fadeAnimation, forKey: "fade")
    }
}




























