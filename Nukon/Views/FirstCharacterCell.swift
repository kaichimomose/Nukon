//
//  FirstCharacterCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/07.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func flashingAnimation(Index: Int)
    func stopFlashingAnimation(Index: Int)
}

class FirstCharacterCell: UICollectionViewCell, CellDelegate {

    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet var characterLabels: [UILabel]!
    
    var japaneseCharactersCVC: JapaneseCharactersCollectionViewController? {
        didSet {
            japaneseCharactersCVC?.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        characterLabels.forEach { label in
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 0.5
            label.layer.cornerRadius = 22.5
            label.layer.masksToBounds = true
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
//        let height = systemLayoutSizeFitting(attributes.size).height
        
        attributes.size.height = UIScreen.main.bounds.width - 100
        attributes.size.width = UIScreen.main.bounds.width - 100
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }
    
    func flashingAnimation(Index: Int) {
        self.characterLabels[Index].alpha = 0.3
        
        let flashing = {
            self.characterLabels[Index].alpha = 1
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .curveEaseInOut], animations: flashing, completion: nil)
    }
    
    func stopFlashingAnimation(Index: Int) {
        self.characterLabels[Index].layer.removeAllAnimations()
    }
    
}
