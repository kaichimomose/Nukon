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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard.init(name: "HiraganaHomeScreen", bundle: .main)
        
        let hiraganaController = storyboard.instantiateViewController(withIdentifier: "Home") as! HiraganaHomeScreenViewController
        hiraganaController.japaneseType = .hiragana
        hiraganaController.backgroundColor = UIColor.hiraganaBackground
        hiraganaController.tabBarItem = UITabBarItem(title: "HIRAGANA", image: #imageLiteral(resourceName: "hiraganaSym"), tag: 0)
        
        let katakanaController = storyboard.instantiateViewController(withIdentifier: "Home") as! HiraganaHomeScreenViewController
        katakanaController.japaneseType = .katakana
        katakanaController.backgroundColor = UIColor.katakanaBackground
        katakanaController.tabBarItem = UITabBarItem(title: "KATAKANA", image: #imageLiteral(resourceName: "katakanaSym"), tag: 1)
        
        self.viewControllers = [hiraganaController, katakanaController]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
