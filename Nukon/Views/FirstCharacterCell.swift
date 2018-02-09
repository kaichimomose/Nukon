//
//  FirstCharacterCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/07.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class FirstCharacterCell: UICollectionViewCell {

    @IBOutlet weak var characterLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
//        let height = systemLayoutSizeFitting(attributes.size).height
        
        attributes.size.height = UIScreen.main.bounds.width - 100
        attributes.size.width = UIScreen.main.bounds.width - 100
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }

}
