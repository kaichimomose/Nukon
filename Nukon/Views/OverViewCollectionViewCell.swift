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
    var selectedJapanese: [String?]! {
        didSet {
            for i in 0..<selectedJapanese.count {
                if selectedJapanese[i] != nil {
                    checkboxesImageViews[i].image = #imageLiteral(resourceName: "checkedcheckbox")
                } else {
                    checkboxesImageViews[i].image = #imageLiteral(resourceName: "emptycheckbox")
                }
            }
        }
    }
    
    var japanese: Japanese! {
        didSet {
            for i in 0..<japanese.letters.count {
                if japanese.letters[i] == "　" {
                    chracterViews[i].backgroundColor = .white
                    checkboxesImageViews[i].isHidden = true
                    characterLabels[i].isHidden = true
                    soundLabels[i].isHidden = true
                } else {
                    chracterViews[i].backgroundColor = .red
                    checkboxesImageViews[i].isHidden = false
                    characterLabels[i].isHidden = false
                    soundLabels[i].isHidden = false
                    characterLabels[i].text = japanese.letters[i]
                    if japanese.sound == "vowel" {
                        soundLabels[i].text = vowels[i]
                    } else {
                        soundLabels[i].text = japanese.sound.lowercased() + vowels[i]
                    }
                }
            }
        }
    }
    let vowels = JapaneseCharacters().vowelSounds
    
    var characterLabels: [UILabel]!
    var soundLabels: [UILabel]!
    
    var delegate: GetValueFormCell?
    
    //MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var chracterViews: [UIView]!
    var checkboxesImageViews: [UIImageView]!
    
    @IBOutlet weak var aCheckboxImageView: UIImageView!
    @IBOutlet weak var iCheckboxImageView: UIImageView!
    @IBOutlet weak var uCheckboxImageView: UIImageView!
    @IBOutlet weak var eCheckboxImageView: UIImageView!
    @IBOutlet weak var oCheckboxImageView: UIImageView!
    @IBOutlet weak var nCheckboxImageView: UIImageView!
    
    @IBOutlet weak var aVowelCharacter: UILabel!
    @IBOutlet weak var iVowelCharacter: UILabel!
    @IBOutlet weak var uVowelCharacter: UILabel!
    @IBOutlet weak var eVowelCharacter: UILabel!
    @IBOutlet weak var oVowelCharacter: UILabel!
    @IBOutlet weak var nVowelCharacter: UILabel!
    
    @IBOutlet weak var aVowelSound: UILabel!
    @IBOutlet weak var iVowelSound: UILabel!
    @IBOutlet weak var uVowelSound: UILabel!
    @IBOutlet weak var eVowelSound: UILabel!
    @IBOutlet weak var oVowelSound: UILabel!
    @IBOutlet weak var nVowelSound: UILabel!
    
    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chracterViews.forEach { view in
            view.layer.cornerRadius = view.frame.size.height/2
        }
        
        checkboxesImageViews = [aCheckboxImageView, iCheckboxImageView, uCheckboxImageView, eCheckboxImageView, oCheckboxImageView, nCheckboxImageView]
        
        checkboxesImageViews.forEach { imageView in
            imageView.backgroundColor = .white
            imageView.layer.cornerRadius = imageView.frame.size.height/2
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.masksToBounds = true
        }
        
        characterLabels = [aVowelCharacter, iVowelCharacter, uVowelCharacter, eVowelCharacter, oVowelCharacter, nVowelCharacter]
        
        soundLabels = [aVowelSound, iVowelSound, uVowelSound, eVowelSound, oVowelSound, nVowelSound]
        
    }
    
    func checkUncheckBox(index: Int) {
        let imageView: UIImageView = self.checkboxesImageViews[index]
        let label: UILabel = self.characterLabels[index]
        if imageView.image == #imageLiteral(resourceName: "checkedcheckbox") {
            imageView.image = #imageLiteral(resourceName: "emptycheckbox")
            self.delegate?.deselectCharacter(consonant: japanese.sound, index: index)
        } else {
            imageView.image = #imageLiteral(resourceName: "checkedcheckbox")
            self.delegate?.selectCharacter(consonant: japanese.sound, index: index, character: label.text!)
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

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
        let height = systemLayoutSizeFitting(attributes.size).height
        
        attributes.size.height = height
        attributes.size.width = UIScreen.main.bounds.width - 20
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }
}
