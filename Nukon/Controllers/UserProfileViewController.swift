//
//  UserProfileViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet var backSuper: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var leaderboardIcon: UIImageView!
    @IBOutlet weak var updatedViewWithArc: Arc!
    
    //LABELS
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var numOfPointsLabel: UILabel!
    
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var numOfdaysLabel: UILabel!
    
    
    @IBOutlet weak var wordsToReviewLabel: UILabel!
    @IBOutlet weak var numOfWordsToReviewLabel: UILabel!
    
    
    @IBOutlet weak var wordsLearntLabel: UILabel!
    @IBOutlet weak var numOfwordsLearntLabel: UILabel!
    
    
    
    let arclayer = CAShapeLayer()
    
    //create leaderBoardIcon programmatically
    func create() {
        leaderboardIcon.center = CGPoint(x: updatedViewWithArc.frame.width/2.95,
                 y: updatedViewWithArc.frame.height - 10)
        let size = CGSize(width: 90.0, height: 90.0)
        leaderboardIcon.sizeThatFits(size)
    }
    
    
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
        iconGradient.isGeometryFlipped = false
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
    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180.0)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpImage()
//        setUpLeaderBoardIcon()
        
        //create leader board icon
        create()
        setUpIconGradient()

        
        
        // Do any additional setup after loading the view.
        profileImage.layer.addSublayer(layer)
//        leaderboardIcon.layer.addSublayer(iconGradient)
        
        
        
        
        updatedViewWithArc.setUp()
        updatedViewWithArc.configure()
//        view.addSubview(updatedViewWithArc)
        
        setUpGradient()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.pointsLabel.center.x += self.view.bounds.width
        numOfPointsLabel.center.x += view.bounds.width
        
        longestStreakLabel.center.x += view.bounds.width
        numOfdaysLabel.center.x += view.bounds.width
        
        wordsToReviewLabel.center.x -= view.bounds.width
        numOfWordsToReviewLabel.center.x -= view.bounds.width
        
        wordsLearntLabel.center.x -= view.bounds.width
        numOfwordsLearntLabel.center.x -= view.bounds.width
        
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
                        self.numOfdaysLabel.center.x -= self.view.bounds.width
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
                        self.numOfwordsLearntLabel.center.x += self.view.bounds.width
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
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //ANIMATIONS
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



