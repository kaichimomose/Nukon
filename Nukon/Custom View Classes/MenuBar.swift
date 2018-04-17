//
//  MenuBar.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/03/04.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let practiceCellId = "PracticeMenuCell"
    let cellId = "MenuCell"
    let imageName = ["consonantOverview", "circle_collection"]
    let practiceType = ["SPEAKING", "WRITING"]
    
    weak var japaneseCharacterCVC: JapaneseCharactersCollectionViewController?
    
    weak var practiceVC: PracticeViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if japaneseCharacterCVC != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
            cell.iconImageView.image = UIImage(named: imageName[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = .lightGray
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: practiceCellId, for: indexPath) as! PracticeMenuCell
            cell.PracticeTypeLabel.text = practiceType[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let japaneseCharacterCVC = self.japaneseCharacterCVC {
            japaneseCharacterCVC.scrollToItemIndexPath(menuindex: indexPath.row)
        } else if let practiceVC = self.practiceVC {
            practiceVC.scrollToItemIndexPath(menuindex: indexPath.row)
        }
    }
    
}

