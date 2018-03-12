//
//  HiraganaHomeScreenViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 2/27/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class HiraganaHomeScreenViewController: UIViewController {
    
    //MARK: - Properties
    var pulsatingLayer: CAShapeLayer!
    
    var effects = SoundEffects()
    
    var swoosh: Swoosh!
    
    var popCount = 0
    
    var backgroundColor: UIColor!
    
    var japaneseType: JapaneseType! {
        didSet {
            if japaneseType == .hiragana {
                yVowelJapanese = .yVowelHiragana
            } else {
                yVowelJapanese = .yVowelKatakana
            }
        }
    }
    
    var yVowelJapanese: JapaneseType!
    
    let coreDataStack = CoreDataStack.instance
    
    var showingCharacters = [String: [String]]()
    var characterDict = [String: WordLearnt]()
    var consonantDict = [String: Consonant]()
    
    //MARK: - Outlets
    @IBOutlet weak var titleRomeLabel: UILabel!
    
    @IBOutlet weak var titleJapaneseLabel: UILabel!
    
    @IBOutlet weak var homeSunButton: UIButton!
    
    @IBOutlet weak var studyButton: studyButton!
    
    @IBOutlet weak var comboButton: combosButtons!
    
    @IBOutlet weak var characterButton: characterListButton!

    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set backgound color
        self.view.backgroundColor = self.backgroundColor
        
        //set title
        titleRomeLabel.text = japaneseType.rawValue
        
        if japaneseType == .hiragana {
            titleJapaneseLabel.text = "ひらがな"
        } else {
            titleJapaneseLabel.text = "カタカナ"
        }
        
        //Bring Home Sun Button to the front
        view.bringSubview(toFront: homeSunButton)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Commence shadow animations
        homeSunButton.animateShadow(pulsing: true)
        
        //Create pulsating layer on View Controller's View
        createPulseLayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    
    
    //fetch core data
    func fetchCoredata(){
        // Initialize Fetch Request\
        let fetchRequest: NSFetchRequest<Consonant> = Consonant.fetchRequest()
        // Add Specific type Descriptors
        fetchRequest.predicate = NSPredicate(format: "system == %@ OR system == %@", japaneseType.rawValue, yVowelJapanese.rawValue)
        do {
            let result = try self.coreDataStack.viewContext.fetch(fetchRequest)

            for item in result {
                guard let consonant = item.consonant else {return}
                if item.isUnlocked {
                    showingCharacters[consonant] = []
                    let words = item.words?.allObjects as? [WordLearnt]
                    guard let wordsLearnt = words else {return}
                    for wordLearnt in wordsLearnt {
                        showingCharacters[consonant]?.append(wordLearnt.word!)
                        characterDict[wordLearnt.word!] = wordLearnt
                    }
                    //sort letters
                    showingCharacters[consonant]!.sort()
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - Actions
    //MAIN BUTTON'S ACTION WHEN PRESSED
    @IBAction func sunPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.12, animations: {
            self.homeSunButton.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            UIView.animate(withDuration: 0.12, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4, options: .curveLinear, animations: {
                self.homeSunButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        //When sun button is pressed, animate the pulsating layer
        if popCount == 0 {
            homeSunButton.animateShadow(pulsing: false)
            animatePulsatingLayer()
            popOutMenuButtons()
            popCount += 1
        } else {
            homeSunButton.animateShadow(pulsing: true)
            animatePulsatingLayer()
            popInMenuButtons()
            popCount -= 1
        }
        
    }
    
    
    @IBAction func studyButtonPressed(_ sender: Any) {
        fetchCoredata()
        if !self.showingCharacters.isEmpty {
            let storyboard = UIStoryboard(name: "Speaking", bundle: .main)
            let showCharacterVC = storyboard.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
            showCharacterVC.japaneseDictForRandom = self.showingCharacters
            showCharacterVC.japaneseType = self.japaneseType
            showCharacterVC.characterCoreDataDict = self.characterDict
            showCharacterVC.backgroundColor = self.backgroundColor
            present(showCharacterVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func comboButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CharactersSelection", bundle: .main)
        let japaneseCharactersCVC = storyboard.instantiateViewController(withIdentifier: "CharactersSelection") as! JapaneseCharactersCollectionViewController
        japaneseCharactersCVC.japaneseType = self.yVowelJapanese
        japaneseCharactersCVC.backgoundColor = self.backgroundColor
        self.present(japaneseCharactersCVC, animated: true)
    }
    
    @IBAction func charButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CharactersSelection", bundle: .main)
        let japaneseCharactersCVC = storyboard.instantiateViewController(withIdentifier: "CharactersSelection") as! JapaneseCharactersCollectionViewController
        japaneseCharactersCVC.japaneseType = self.japaneseType
        japaneseCharactersCVC.backgoundColor = self.backgroundColor
        self.present(japaneseCharactersCVC, animated: true)
    }

}

extension HiraganaHomeScreenViewController {
    
    //Animations
    private func createPulseLayer() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 0.1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = UIColor.white.cgColor
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
    }
    
   //Pulsating animations
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        
        //initial values
        animation.toValue = 950
        fadeAnimation.fromValue = 1
        
        //how long animation runs
        animation.duration = 0.4
        fadeAnimation.duration = 0.45
        
        //ending values of animations
        fadeAnimation.toValue = 0
        
        //animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsating")
        pulsatingLayer.add(fadeAnimation, forKey: "fade")
    }
    
    
    //Menu Button Animations -----------------------------------------------------
    func popOutMenuButtons() {
        UIView.animate(withDuration: 0.2, delay: 0.125, options: .curveEaseInOut, animations: {
            self.studyButton.center.x = self.studyButton.center.x - 135
            self.effects.swooshEffect(Swoosh.one)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.comboButton.center.y = self.comboButton.center.y - 135
                self.effects.swooshEffect(Swoosh.two)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.characterButton.center.x = self.characterButton.center.x + 135
                    self.effects.swooshEffect(Swoosh.three)
                }, completion: nil)
            })
        }
    }
    
    func popInMenuButtons() {
        UIView.animate(withDuration: 0.2, delay: 0.125, options: .curveEaseInOut, animations: {
            self.studyButton.center.x = self.studyButton.center.x + 135
            self.effects.swooshEffect(Swoosh.backOne)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.comboButton.center.y = self.comboButton.center.y + 135
                self.effects.swooshEffect(Swoosh.backTwo)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.characterButton.center.x = self.characterButton.center.x - 135
                        self.effects.swooshEffect(Swoosh.backThree)
                }, completion: nil)
            })
        }
    }
}

