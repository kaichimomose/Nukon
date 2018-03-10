//
//  MenuCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/03/04.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    @IBOutlet weak var menuBarView: UIView! {
        didSet {
            menuBarView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.tintColor = .lightGray
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            iconImageView.tintColor = isHighlighted ? .redSun : .lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            iconImageView.tintColor = isSelected ? .redSun : .lightGray
        }
    }
    
}
