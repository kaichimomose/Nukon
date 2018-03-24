//
//  AlertHelper.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/12.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import Foundation
import UIKit

protocol AlertPresentable: class {
    func selectChallengeAlert()
}

extension AlertPresentable where Self: UIViewController {
    func selectChallengeAlert(){
        let alertVC = UIAlertController(
            title: "This is locked!",
            message: "Until you learn at least one character.",
            preferredStyle: .alert
        )
        
        alertVC.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    
            })
        )
        
        self.present(alertVC, animated: true, completion: nil)
    }

}
