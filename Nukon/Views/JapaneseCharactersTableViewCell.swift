//
//  JapaneseCharactersTableViewCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class JapaneseCharactersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var consonantView: UIView!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var japaneseCharactersLabel: UILabel!
    @IBOutlet weak var vowelALabel: UILabel!
    @IBOutlet weak var vowelILabel: UILabel!
    @IBOutlet weak var vowelULabel: UILabel!
    @IBOutlet weak var vowelELabel: UILabel!
    @IBOutlet weak var vowelOLabel: UILabel!
    @IBOutlet weak var vowelVoidLabel: UILabel!
    
    var letters: [String]! {
        didSet {
            vowelALabel.text = letters[0]
            vowelILabel.text = letters[1]
            vowelULabel.text = letters[2]
            vowelELabel.text = letters[3]
            vowelOLabel.text = letters[4]
            vowelVoidLabel.text = letters[5]
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
