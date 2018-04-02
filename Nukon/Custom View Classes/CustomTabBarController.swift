//
//  CustomTabBarController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/03/10.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    //MARK:
    var hiraganaController = HiraganaHomeScreenViewController()
    var katakanaController = HiraganaHomeScreenViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard.init(name: "HiraganaHomeScreen", bundle: .main)
        
        hiraganaController = storyboard.instantiateViewController(withIdentifier: "Home") as! HiraganaHomeScreenViewController
        hiraganaController.japaneseType = .hiragana
        hiraganaController.backgroundColor = UIColor.hiraganaBackground
        hiraganaController.tabBarItem = UITabBarItem(title: "HIRAGANA", image: #imageLiteral(resourceName: "hirachar"), tag: 0)
        
        katakanaController = storyboard.instantiateViewController(withIdentifier: "Home") as! HiraganaHomeScreenViewController
        katakanaController.japaneseType = .katakana
        katakanaController.backgroundColor = UIColor.katakanaBackground
        katakanaController.tabBarItem = UITabBarItem(title: "KATAKANA", image: #imageLiteral(resourceName: "katachar"), tag: 1)
        
        self.viewControllers = [hiraganaController, katakanaController]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "HIRAGANA" {
            katakanaController.popInMenuButtons()
            katakanaController.popCount = 0
        } else {
            hiraganaController.popInMenuButtons()
            hiraganaController.popCount = 0
        }
    }

}
