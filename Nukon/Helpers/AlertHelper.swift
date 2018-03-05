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
    
//    func goToShowCharactersVCAlert(closure: @escaping (_ showingStyle: ShowingStyle) -> ()){
//        let alertVC = UIAlertController(
//            title: "Challenge Selections",
//            message: "start practicing",
//            preferredStyle: .alert
//        )
//
//        alertVC.addAction(
//            UIAlertAction(
//                title: "following the order",
//                style: .default,
//                handler: { (action) in
//                    closure(.order)
//            })
//        )
//
//        alertVC.addAction(
//            UIAlertAction(
//                title: "random order",
//                style: .default,
//                handler: { (action) in
//                    closure(.random)
//            })
//        )
//
//        self.present(alertVC, animated: true, completion: nil)
//    }
//
//    func jumpToJCTVCAlert(character: String, closure: @escaping () -> (), sound: @escaping (_ string: String) -> ()){
//        let alertVC = UIAlertController(
//            title: "Practice?",
//            message: "start practicing '\(character)'",
//            preferredStyle: .actionSheet
//        )
//
//        alertVC.addAction(
//            UIAlertAction(
//                title: "Cancel",
//                style: .cancel,
//                handler: { (action) in
//
//            })
//        )
//
//        alertVC.addAction(
//            UIAlertAction(
//                title: "Yes",
//                style: .default,
//                handler: { (action) in
//                 closure()
//            })
//        )
//
//        alertVC.addAction(
//            UIAlertAction(
//                title: "Check Sound",
//                style: .default,
//                handler: { (action) in
//                    sound(character)
//            })
//        )
//
//        self.present(alertVC, animated: true, completion: nil)
//    }
}
