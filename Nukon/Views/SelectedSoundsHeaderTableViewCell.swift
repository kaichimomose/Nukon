//
//  SelectedSoundsHeaderTableViewCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/12.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class SelectedSoundsHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var selectedSoundsLable: UILabel!
    @IBOutlet weak var showSelectedSoundsLable: UILabel!
    
    var selectedJapanese: [Japanese]? {
        didSet {
            var soundsList = [String]()
            for japanese in selectedJapanese! {
                soundsList.append(japanese.sound)
            }
            showSelectedSoundsLable.text = soundsList.joined(separator: ", ")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
