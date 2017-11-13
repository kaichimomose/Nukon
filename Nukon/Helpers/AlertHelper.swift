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
    func selectAlert()
}

extension AlertPresentable where Self: UIViewController {
    func selectAlert(){
        let alertVC = UIAlertController(
            title: "Error",
            message: "Please choose at least one sound",
            preferredStyle: .alert
        )
        
        alertVC.addAction(
            UIAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action) in
                    
            })
        )
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
