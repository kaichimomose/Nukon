//
//  UserProfileViewController.swift
//  Nukon
//
//  Created by Chiris Mauldin on 2017/10/25.
//  Copyright © 2017 Chiris Mauldin. All rights reserved.
//

import UIKit


class UserProfileViewController: UIViewController, UITabBarControllerDelegate {



    @IBOutlet weak var updatedViewWithArc: UIView!
    @IBOutlet weak var profileIcon: CustomImageView!
    
    //LABELS
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var numOfPointsLabel: UILabel!
    
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var numOfDaysLabel: UILabel!

    
    
    @IBOutlet weak var wordsToReviewLabel: UILabel!
    @IBOutlet weak var numOfWordsToReviewLabel: UILabel!
    
    
    @IBOutlet weak var wordsLearntLabel: UILabel!
    @IBOutlet weak var numOfWordsLearntLabel: UILabel!

    var userDatas = [UserData]()
    var userData: UserData!
    var wordsLearnt = [WordLearnt]()
    

    var numberOfWordsLearnt = [WordLearnt]()
    var numberOfWordsToReview = [WordLearnt]()
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width / 2
//        self.profileIcon.layer.borderColor = UIColor.cyan.cgColor
//        self.profileIcon.layer.borderWidth = 2
        
        self.tabBarController?.delegate = self
        
        let arcMask = UIImageView(image: #imageLiteral(resourceName: "Rectangle"))
        updatedViewWithArc.mask = arcMask
        
        //RETRIEVE CORE DATA
        wordsLearnt = CoreDataHelper.retrieveWordLearnt()
        userDatas = CoreDataHelper.retrieveUserData()

        
        if userDatas == [] {
            userData =  CoreDataHelper.newUserData()
            userData.loginDate = Date().convertToString().components(separatedBy: ",")[0]
            userData.nextDateofLoginDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())?.convertToString().components(separatedBy: ",")[0]
            userData.streak = 1
            userData.longestStreak = 1
            userData.points = 0
        }
        else {
            userData = userDatas[0]
            let userLastLoginDate = userData.loginDate
            let correntDate = Date().convertToString().components(separatedBy: ",")[0]
            if userLastLoginDate != correntDate {
                let nextDateOfUserLastLoginDate = userData.nextDateofLoginDate
                if nextDateOfUserLastLoginDate == correntDate {
                    userData.streak += 1
                    if userData.streak > userData.longestStreak {
                        userData.longestStreak = userData.streak
                    }
                }
                else {
                    userData.streak = 0
                }
            }
            userData.loginDate = Date().convertToString().components(separatedBy: ",")[0]
            userData.nextDateofLoginDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())?.convertToString().components(separatedBy: ",")[0]
        }
        CoreDataHelper.saveUserData()
        numOfPointsLabel.text = String(userData.points)
        numOfDaysLabel.text = String(userData.longestStreak)
        
        if wordsLearnt == [] {
            numOfWordsLearntLabel.text = String(0)
        }
        else {
            self.numberOfWordsLearnt = [WordLearnt]()
            self.numberOfWordsToReview = [WordLearnt]()
            for wordLearnt in wordsLearnt {
//                if wordLearnt.numberOfCorrect > wordLearnt.numberOfWrong {
//                    self.numberOfWordsLearnt.append(wordLearnt)
//                }
                if wordLearnt.numberOfCorrect >= 5 {
                    self.numberOfWordsLearnt.append(wordLearnt)
                }
                else {
                    self.numberOfWordsToReview.append(wordLearnt)
                }
//                CoreDataHelper.delete(wordLearnt: wordLearnt)
            }
            numOfWordsToReviewLabel.text = String(numberOfWordsToReview.count)
            numOfWordsLearntLabel.text = String(numberOfWordsLearnt.count)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.pointsLabel.center.x += self.view.bounds.width
        numOfPointsLabel.center.x += view.bounds.width
        
        longestStreakLabel.center.x += view.bounds.width
        numOfDaysLabel.center.x += view.bounds.width
        
        wordsToReviewLabel.center.x -= view.bounds.width
        numOfWordsToReviewLabel.center.x -= view.bounds.width
        
        wordsLearntLabel.center.x -= view.bounds.width
        numOfWordsLearntLabel.center.x -= view.bounds.width

        
        //ANIMATIONS
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseInOut],
                       animations: {
                        self.pointsLabel.center.x -= self.view.bounds.width
                        self.numOfPointsLabel.center.x -= self.view.bounds.width
                        },
                       completion: nil
        )

        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.curveEaseIn],
                       animations: {
                        self.longestStreakLabel.center.x -= self.view.bounds.width
                        self.numOfDaysLabel.center.x -= self.view.bounds.width

        },
                       completion: nil
        )


        UIView.animate(withDuration: 0.7, delay: 0.6, options: [.curveEaseIn],
                       animations: {
                        self.wordsToReviewLabel.center.x += self.view.bounds.width
                        self.numOfWordsToReviewLabel.center.x += self.view.bounds.width
        },
                       completion: nil)


        UIView.animate(withDuration: 0.8, delay: 0.8, options: [.curveEaseIn],
                       animations: {
                        self.wordsLearntLabel.center.x += self.view.bounds.width
                        self.numOfWordsLearntLabel.center.x += self.view.bounds.width
        },
                       completion: nil)

    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //do your stuff
            self.viewDidLoad()
        } else {
//            let navigationVC = tabBarController.viewControllers![1]
//            let practiceVC = navigationVC.childViewControllers.first as! PracticeViewController
//            practiceVC.japaneseType = nil
//            practiceVC.sound = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToUserProfileViewController(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //tap gesture identifier
        let reviewTVC = segue.destination as! ReviewTableViewController
        if segue.identifier == "wordslearnt" {
            reviewTVC.title = self.wordsLearntLabel.text! + ": " + self.numOfWordsLearntLabel.text!
            reviewTVC.wordsLearnt = self.numberOfWordsLearnt
        } else {
            reviewTVC.title = self.wordsToReviewLabel.text! + ": " + self.numOfWordsToReviewLabel.text!
            reviewTVC.wordsLearnt = self.numberOfWordsToReview
        }
    }

}



