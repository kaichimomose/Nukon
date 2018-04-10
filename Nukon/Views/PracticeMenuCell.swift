//
//  PracticeMenuCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/09.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class PracticeMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var PracticeTypeLabel: UILabel! {
        didSet {
            PracticeTypeLabel.textColor = .lightGray
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            PracticeTypeLabel.textColor = isHighlighted ? .redSun : .lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            PracticeTypeLabel.textColor = isSelected ? .redSun : .lightGray
        }
    }
}
