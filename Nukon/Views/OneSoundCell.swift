//
//  OneSoundCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/07.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class OneSoundCell: UICollectionViewCell {

    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        characterLabel.layer.borderWidth = 1
        characterLabel.layer.borderColor = UIColor.black.cgColor
        characterLabel.layer.cornerRadius = (UIScreen.main.bounds.width - 10)/6/2
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
//        let height = systemLayoutSizeFitting(attributes.size).height
        
        attributes.size.height = 100
        attributes.size.width = (UIScreen.main.bounds.width - 10)/6
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }
}
