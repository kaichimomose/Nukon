//
//  UserProfileViewController.swift
//  Nukon
//
//  Created by Chiris Mauldin on 2017/10/25.
//  Copyright © 2017 Chiris Mauldin. All rights reserved.
//

import UIKit


class UserProfileViewController: UIViewController, UITabBarControllerDelegate {


    @IBOutlet var backSuper: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var leaderboardIcon: UIImageView!
    @IBOutlet weak var updatedViewWithArc: Arc!
    
    //LABELS
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var numOfPointsLabel: UILabel!
    
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var numOfDaysLabel: UILabel!

    
    
    @IBOutlet weak var wordsToReviewLabel: UILabel!
    @IBOutlet weak var numOfWordsToReviewLabel: UILabel!
    
    
    @IBOutlet weak var wordsLearntLabel: UILabel!
    @IBOutlet weak var numOfWordsLearntLabel: UILabel!

    let arclayer = CAShapeLayer()
    var userDatas = [UserData]()
    var userData: UserData!
    var wordsLearnt = [WordLearnt]()
    
    var numberOfWordsLearnt = [WordLearnt]()
    var numberOfWordsToReview = [WordLearnt]()
    
    //create leaderBoardIcon programmatically
    let gradientLayer = CAGradientLayer()
    let iconGradient = CAGradientLayer()
    let layer = CALayer()
    let leaderLayer = CALayer()
    let prof = UIImage(named: "profile-1")?.cgImage
    let leaderIcon = UIImage(named: "leaderboard")?.cgImage
    
    func setUpGradient() {
        gradientLayer.colors = [
//            UIColor(red: 255/255, green: 75/255, blue: 52/255, alpha: 1).cgColor,
            UIColor(red: 236/255, green: 75/255, blue: 164/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 120/255, blue: 52/255, alpha: 1).cgColor,
            UIColor(red: 252/255, green: 252/255, blue: 103/255, alpha: 1).cgColor
        ]
        
        gradientLayer.locations = [0.35, 0.75, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradientLayer.frame = backSuper.frame
        backSuper.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setUpIconGradient() {
        iconGradient.frame = leaderboardIcon.frame
        iconGradient.contents = leaderIcon
        iconGradient.contentsGravity = kCAGravityCenter
//        iconGradient.isGeometryFlipped = false
        iconGradient.cornerRadius = iconGradient.frame.width/2
//        iconGradient.shadowOpacity = 0.7
//        iconGradient.shadowRadius = 2.0
//        iconGradient.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        iconGradient.colors = [
//            UIColor(red: 255/255, green: 75/255, blue: 52/255, alpha: 1).cgColor,
            UIColor(red: 236/255, green: 75/255, blue: 164/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 120/255, blue: 52/255, alpha: 1).cgColor,
            UIColor(red: 252/255, green: 252/255, blue: 103/255, alpha: 1).cgColor
        ]
        
        iconGradient.locations = [0.00, 0.65, 1.0]
        iconGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        iconGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        iconGradient.frame = leaderboardIcon.frame
        leaderboardIcon.layer.insertSublayer(iconGradient, at: 0)
        print(iconGradient.frame)
    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self

        setUpGradient()
        
        updatedViewWithArc.setUp()
        updatedViewWithArc.configure()
        
        profileImage.layer.addSublayer(layer)
        setUpImage()
        

        

        //retrive core data
        wordsLearnt = CoreDataHelper.retrieveWordLearnt()
        userDatas = CoreDataHelper.retrieveUserData()
        
        //set up labels and images

        setUpImage()
//        setUpLeaderBoardIcon()
        
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
                if wordLearnt.numberOfCorrect > wordLearnt.numberOfWrong {
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
//        CoreDataHelper.saveWordLearnt()
        
        //create leader board icon
//        create()
//        setUpIconGradient()

        
        
//        // Do any additional setup after loading the view.
//        profileImage.layer.addSublayer(layer)
////        leaderboardIcon.layer.addSublayer(iconGradient)
//        
//        
//        
//        
//        updatedViewWithArc.setUp()
//        updatedViewWithArc.configure()
//        view.addSubview(updatedViewWithArc)
    
        //add shape object to view
//        let arcView = Arc(origin: view.center)
//        self.view.addSubview(arcView)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        //start up label positions
//        super.viewWillAppear(animated)
//        self.points.center.x += self.view.bounds.width
//        numOfPoints.center.x += view.bounds.width
//
//        longestStreak.center.x -= view.bounds.width
//        numOfdays.center.x -= view.bounds.width
//
//        wordsToReview.center.x -= view.bounds.width
//        numOfWordsToReview.center.x -= view.bounds.width
//
//        wordsLearnt.center.x -= view.bounds.width
//        numOfwordsLearnt.center.x -= view.bounds.width
//
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        create()
//        setUpIconGradient()
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
//
    }
    
    
    func setUpImage() {
        layer.frame = profileImage.bounds
        layer.contents = prof
        layer.contentsGravity = kCAGravityCenter
        layer.isGeometryFlipped = false
        layer.cornerRadius = layer.frame.width / 2
//        layer.backgroundColor = UIColor(red: 236/255, green: 75/255, blue: 164/255, alpha: 0.90).cgColor
        layer.backgroundColor = UIColor.white.cgColor
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //do your stuff
            self.viewDidLoad()
        } else {
            let navigationVC = tabBarController.viewControllers![1]
            let practiceVC = navigationVC.childViewControllers.first as! PracticeViewController
            practiceVC.japaneseType = nil
            practiceVC.sound = nil
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
        let ReviewTVC = segue.destination as! ReviewTableViewController
        if segue.identifier == "wordslearnt" {
            ReviewTVC.wordsLearnt = self.numberOfWordsLearnt
        } else {
            ReviewTVC.wordsLearnt = self.numberOfWordsToReview
        }
    }
}



