//
//  OverViewCollectionViewCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/25.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class OverViewCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var isUnLocked: Bool!
    var characterDict: [String: WordLearnt]!
    
    var japanese: Japanese! {
        didSet {
            let numberOfCharacters = japanese.letters.count
            let soundList = JapaneseCharacters().soundsList[japanese.sound]
            switch numberOfCharacters {
                case 3:
                    for i in 0..<japanese.letters.count {
                        let apperIndex = i*2
                        let character = japanese.letters[i]
                        checkboxesImageViews[apperIndex].isHidden = false
                        characterLabels[apperIndex].alpha = 1
                        soundLabels[apperIndex].alpha = 1
                        characterLabels[apperIndex].text = character
                        self.coloringAndUnlock(character: character, index: apperIndex)
                        soundLabels[apperIndex].text = soundList?[i]
                        if i < 2 {
                            let hideIndex = apperIndex + 1
                            chracterViews[hideIndex].backgroundColor = .clear
                            checkboxesImageViews[hideIndex].isHidden = true
                            characterLabels[hideIndex].alpha = 0
                            soundLabels[hideIndex].alpha = 0
                        }
                    }
                case 2:
                    for i in 0..<japanese.letters.count {
                        let apperIndex = i*4
                        let character = japanese.letters[i]
                        checkboxesImageViews[apperIndex].isHidden = false
                        characterLabels[apperIndex].alpha = 1
                        soundLabels[apperIndex].alpha = 1
                        characterLabels[apperIndex].text = character
                        self.coloringAndUnlock(character: character, index: apperIndex)
                        soundLabels[apperIndex].text = soundList?[i]
                    }
                    for j in 1...3 {
                        chracterViews[j].backgroundColor = .clear
                        checkboxesImageViews[j].isHidden = true
                        characterLabels[j].alpha = 0
                        soundLabels[j].alpha = 0
                    }
                case 1:
                    let character = japanese.letters[0]
                    checkboxesImageViews[2].isHidden = false
                    characterLabels[2].alpha = 1
                    soundLabels[2].alpha = 1
                    self.coloringAndUnlock(character: character, index: 2)
                    characterLabels[2].text = character
                    soundLabels[2].text = soundList?[0]
                    for i in 0..<5 {
                        if i != 2 {
                            chracterViews[i].backgroundColor = .clear
                            checkboxesImageViews[i].isHidden = true
                            characterLabels[i].alpha = 0
                            soundLabels[i].alpha = 0
                        }
                    }
                default:
                    for i in 0..<japanese.letters.count {
                        let character = japanese.letters[i]
                        self.coloringAndUnlock(character: character, index: i)
                        checkboxesImageViews[i].isHidden = false
                        characterLabels[i].alpha = 1
                        soundLabels[i].alpha = 1
                        characterLabels[i].text = character
                        soundLabels[i].text = soundList?[i]
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
    
    let vowels = JapaneseCharacters().vowelSounds
    
    var characterLabels: [UILabel]!
    var soundLabels: [UILabel]!
    
    weak var delegate: GetValueFromCell?
    
    //MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var chracterViews: [UIView]!
    var checkboxesImageViews: [UIImageView]!
    
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
    
    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chracterViews.forEach { view in
            view.layer.cornerRadius = view.frame.size.height/2
        }
        
        checkboxesImageViews = [aCheckboxImageView, iCheckboxImageView, uCheckboxImageView, eCheckboxImageView, oCheckboxImageView]
        
        checkboxesImageViews.forEach { imageView in
            imageView.backgroundColor = .white
            imageView.layer.cornerRadius = imageView.frame.size.height/2
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.masksToBounds = true
        }
        
        characterLabels = [aVowelCharacter, iVowelCharacter, uVowelCharacter, eVowelCharacter, oVowelCharacter]
        
        soundLabels = [aVowelSound, iVowelSound, uVowelSound, eVowelSound, oVowelSound]
        
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
    
    func coloringAndUnlock(character: String, index: Int) {
        if let wordLearnt = characterDict[character], isUnLocked {
            switch wordLearnt.confidenceCounter {
            case 4:
                chracterViews[index].backgroundColor = UIColor.materialGreen //Green
            case 3:
                chracterViews[index].backgroundColor = UIColor.materialLightGreen //LightGreen
            case 2:
                chracterViews[index].backgroundColor = UIColor.materialYellow //dark yellow
            case 1:
                chracterViews[index].backgroundColor = UIColor.materialOrange //Orange
            default:
                chracterViews[index].backgroundColor = UIColor.redSun //Red
            }
            
            chracterViews[index].alpha = 1
            
            checkboxesImageViews.forEach({ imageView in
                imageView.alpha = 1
            })
            
            buttons.forEach({ button in
                button.isEnabled = true
            })
        } else {
            chracterViews[index].backgroundColor = .lightGray
            chracterViews[index].alpha = 0.5
            
            checkboxesImageViews.forEach({ imageView in
                imageView.alpha = 0.5
            })
            
            buttons.forEach({ button in
                button.isEnabled = false
            })
        }
    }
    
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

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
        let height = systemLayoutSizeFitting(attributes.size).height
        
        attributes.size.height = height
        attributes.size.width = UIScreen.main.bounds.width - 10
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }
}
