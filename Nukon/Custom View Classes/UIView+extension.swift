//
//  UIView+extension.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/03/04.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

extension UIView {
    func addConstrantsWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
