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
    func selectCharactersAlert(japaneseType: JapaneseType, closure: @escaping () -> ())
    func selectCombinationsAlert(japaneseType: JapaneseType, closure: @escaping () -> ())
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
    
    func selectCharactersAlert(japaneseType: JapaneseType, closure: @escaping () -> ()){
        let alertVC = UIAlertController(
            title: "Fundation",
            message: "Here, you can study and learn the fundamental \(japaneseType.rawValue.lowercased()) characters.",
            preferredStyle: .alert
        )
        
        alertVC.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    closure()
            })
        )
        
        self.present(alertVC, animated: true, completion: nil)
    }

    func selectCombinationsAlert(japaneseType: JapaneseType, closure: @escaping () -> ()){
        let alertVC = UIAlertController(
            title: "Advanced",
            message: "Here, \(japaneseType.rawValue.lowercased()) characters are combined to create different sounds.",
            preferredStyle: .alert
        )
        
        alertVC.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    closure()
            })
        )
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
