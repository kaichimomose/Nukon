//
//  SoundsCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/07.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class SoundsCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var firstCharacterLabel: UILabel!
    
    let layout = UICollectionViewFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    var tapped = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "OneSoundCell", bundle: .main), forCellWithReuseIdentifier: "OneSoundCell")
        
        
        let collectionViewWidth = collectionView.frame.width
        let cellWidth = (collectionViewWidth)/6

        layout.scrollDirection = .horizontal
        layout.sectionInset = inset
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: cellWidth, height: 100)
        layout.itemSize = CGSize(width: cellWidth, height: 100)
        
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceHorizontal = true
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as? UICollectionViewLayoutAttributes else {return layoutAttributes}
        
        let height = systemLayoutSizeFitting(attributes.size).height
        
        attributes.size.height = height
        attributes.size.width = UIScreen.main.bounds.width - 10
        //        attributes.size.width = self.contentView.frame.size.width
        return attributes
    }
    
//    @IBAction func labelTapped(_ sender: Any) {
//        firstCharacterLabel.isHidden = true
//
////        collectionView.isHidden = false
//    }
    
    
    
}

extension SoundsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tapped {
            return 5
        } else {
            return 1
        }
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return layout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneSoundCell", for: indexPath) as! OneSoundCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapped = true
        collectionView.reloadData()
    }
    
}

