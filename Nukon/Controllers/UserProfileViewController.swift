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
    @IBOutlet weak var userIcon: CustomImageView!
    //LABELS
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var numOfPointsLabel: UILabel!
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var numOfDaysLabel: UILabel!

    @IBOutlet weak var wordsToReviewLabel: UILabel!
    @IBOutlet weak var numOfWordsToReviewLabel: UIButton!
    
    @IBOutlet weak var wordsLearntLabel: UILabel!
    @IBOutlet weak var numOfWordsLearntLabel: UIButton!
    
    
    var userDatas = [UserData]()
    var userData: UserData!
    var wordsLearnt = [WordLearnt]()
    
    var numberOfWordsLearnt = [WordLearnt]()
    var numberOfWordsToReview = [WordLearnt]()
    
    let photoHelper = MGPhotoHelper()
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar color and text color
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black

        self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width / 2
//        self.profileIcon.layer.borderColor = UIColor.cyan.cgColor
//        self.profileIcon.layer.borderWidth = 2
        
        self.numOfWordsLearntLabel.layer.cornerRadius = 5
        self.numOfWordsLearntLabel.layer.masksToBounds = true
        self.numOfWordsLearntLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.numOfWordsLearntLabel.layer.borderWidth = 2
        
        self.numOfPointsLabel.layer.cornerRadius = 5
        self.numOfPointsLabel.layer.masksToBounds = true
        self.numOfPointsLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.numOfPointsLabel.layer.borderWidth = 2
        
        self.numOfDaysLabel.layer.cornerRadius = 5
        self.numOfDaysLabel.layer.masksToBounds = true
        self.numOfDaysLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.numOfDaysLabel.layer.borderWidth = 2
        
        self.numOfWordsToReviewLabel.layer.cornerRadius = 5
        self.numOfWordsToReviewLabel.layer.masksToBounds = true
        self.numOfWordsToReviewLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.numOfWordsToReviewLabel.layer.borderWidth = 2
        
        self.tabBarController?.delegate = self
        
        let arcMask = UIImageView(image: #imageLiteral(resourceName: "Rectangle"))
        updatedViewWithArc.mask = arcMask
        
    }
    
    func dataUpdate() {
        userDataUpdate()
        wordLearntUpdate()
    }
    
    func userDataUpdate() {
        userDatas = CoreDataHelper.retrieveUserData()
        
        if userDatas == [] {
            userData = CoreDataHelper.newUserData()
            userData.loginDate = Date().convertToString().components(separatedBy: ",")[0]
            userData.nextDateofLoginDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())?.convertToString().components(separatedBy: ",")[0]
            userData.streak = 1
            userData.longestStreak = 1
            userData.points = 0
        }
        else {
            userData = userDatas[0]
            numOfPointsLabel.text = String(userData.points)
            let imageData = userData.userImage
            if let imageData = imageData {
                profileIcon.image = UIImage(data: imageData as Data)
            } else {
                profileIcon.image = nil
            }
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
        numOfDaysLabel.text = String(userData.longestStreak)
    }
    
    func wordLearntUpdate() {
        wordsLearnt = CoreDataHelper.retrieveWordLearnt()
        
        //words data
        if wordsLearnt != [] {
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
            numOfWordsToReviewLabel.setTitle(String(numberOfWordsToReview.count), for: .normal)
            numOfWordsLearntLabel.setTitle(String(numberOfWordsLearnt.count), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.pointsLabel.center.x += self.view.bounds.width
        self.numOfPointsLabel.center.x += self.view.bounds.width
        
        self.longestStreakLabel.center.x += self.view.bounds.width
        self.numOfDaysLabel.center.x += self.view.bounds.width
        
        self.wordsToReviewLabel.center.x -= self.view.bounds.width
        self.numOfWordsToReviewLabel.center.x -= self.view.bounds.width
        
        self.wordsLearntLabel.center.x -= self.view.bounds.width
        self.numOfWordsLearntLabel.center.x -= self.view.bounds.width
        
        DispatchQueue.main.async {
            self.userDataUpdate()
        }
        
        //RETRIEVE CORE DATA
        DispatchQueue.main.async {
            
            self.wordLearntUpdate()
            
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
//                            self.wordsToReviewTapGesture.isEnabled = true
            },
                           completion: nil)
            
            
            UIView.animate(withDuration: 0.8, delay: 0.8, options: [.curveEaseIn],
                           animations: {
                            self.wordsLearntLabel.center.x += self.view.bounds.width
                            self.numOfWordsLearntLabel.center.x += self.view.bounds.width
//                            self.wordsLearntTapGesture.isEnabled = true
            },
                           completion: nil)


        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //do your stuff
            self.navigationController?.navigationBar.barTintColor = .white
        } else {
//            self.viewDidLoad()
//            userDataUpdate()
//            wordLearntUpdate()
            self.navigationController?.navigationBar.barTintColor = .white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToUserProfileViewController(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        photoHelper.completionHandler = setImage(_:)
        photoHelper.deleteFunc = deleteImage
        photoHelper.presentActionSheet(from: self)
    }
    
    func setImage(_ selectedImage: UIImage) {
        let imageData = UIImagePNGRepresentation(selectedImage) as Data?
        userData.userImage = imageData
        CoreDataHelper.saveUserData()
        profileIcon.image = UIImage(data: imageData!)
    }
    
    func deleteImage() {
        userData.userImage = nil
        CoreDataHelper.saveUserData()
        profileIcon.image = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //tap gesture identifier
        let reviewTVC = segue.destination as! ReviewTableViewController
        if segue.identifier == "wordslearnt" {
            reviewTVC.title = self.wordsLearntLabel.text! + ": " + String(numberOfWordsLearnt.count)
            reviewTVC.wordsLearnt = self.numberOfWordsLearnt
        } else {
            reviewTVC.title = self.wordsToReviewLabel.text! + ": " + String(numberOfWordsToReview.count)
            reviewTVC.wordsLearnt = self.numberOfWordsToReview
        }
    }

    
}



