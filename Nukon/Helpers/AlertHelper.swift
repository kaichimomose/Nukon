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
            title: "Oops!!",
            message: "Please choose at least one sound",
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
    
    func jumpToJCTVCAlert(character: String, closure: @escaping () -> ()){
        let alertVC = UIAlertController(
            title: "Practice?",
            message: "start practicing '\(character)'",
            preferredStyle: .actionSheet
        )
        
        alertVC.addAction(
            UIAlertAction(
                title: "No",
                style: .cancel,
                handler: { (action) in
                    
            })
        )
        
        alertVC.addAction(
            UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { (action) in
                 closure()
            })
        )
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
