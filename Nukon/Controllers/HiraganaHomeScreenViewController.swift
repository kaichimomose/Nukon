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

class HiraganaHomeScreenViewController: UIViewController, AlertPresentable,  UIViewControllerTransitioningDelegate {
    
    //MARK: - Properties
    var pulsatingLayer: CAShapeLayer!
    
    var effects = SoundEffects()
    
    var swoosh: Swoosh!
    
    let transition = CircularTransition()
    
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
    
    @IBOutlet var hiraganaDescriptionTextView: UIView!
    
    @IBOutlet var katakanaDescriptionTextView: UIView!
    

    //Mark: Stack View Outlets
    @IBOutlet weak var studyStack: UIStackView!
    
    
    @IBOutlet weak var ComboStack: UIStackView!
    
    
    @IBOutlet weak var characterStack: UIStackView!
    
    
    //Mark: Menu button labels
    @IBOutlet weak var challengeLabel: UILabel!
    
    @IBOutlet weak var comboLabel: UILabel!
    
    @IBOutlet weak var characterLabel: UILabel!
    
    var menuButtons: [UIButton]!
    
    
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
        menuButtons = [self.homeSunButton, self.studyButton, self.comboButton, self.characterButton]
        
        //Menu Button Labels - Make them invisible
        challengeLabel.alpha = 0
        comboLabel.alpha = 0
        characterLabel.alpha = 0
        
        
        studyButton.isEnabled = false
        comboButton.isEnabled = false
        characterButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Commence shadow animations
        homeSunButton.animateShadow(pulsing: true, color: UIColor.redSun)
        
        //Create pulsating layer on View Controller's View
        createPulseLayer()
        
        //Bring in description
        animateIn(with: japaneseType!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.homeSunButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.homeSunButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: .curveEaseInOut, animations: {
                    self.homeSunButton.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
        
        animateSunButtonLabel(show: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func animateIn(with: JapaneseType) {
        
        if japaneseType == .hiragana {
            self.view.addSubview(hiraganaDescriptionTextView)
            self.view.bringSubview(toFront: hiraganaDescriptionTextView)
            
            hiraganaDescriptionTextView.layer.cornerRadius = 7
            hiraganaDescriptionTextView.center = CGPoint(x: view.center.x - (view.center.x * 2), y: view.center.y * 1.55)
            hiraganaDescriptionTextView.alpha = 0
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.hiraganaDescriptionTextView.center.x = self.view.center.x
                self.hiraganaDescriptionTextView.alpha = 1
            }, completion: nil)
            
        } else {
            self.view.addSubview(katakanaDescriptionTextView)
            self.view.bringSubview(toFront: katakanaDescriptionTextView)
            katakanaDescriptionTextView.layer.cornerRadius = 7
            katakanaDescriptionTextView.center = CGPoint(x: view.center.x + (view.center.x * 2), y: view.center.y * 1.55)
            katakanaDescriptionTextView.alpha = 0
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.katakanaDescriptionTextView.center.x = self.view.center.x
                self.katakanaDescriptionTextView.alpha = 1
            }, completion: nil)
            
        }
    }
    
    func animateOut(type: JapaneseType) {
        
        if type == .hiragana {
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 7, options: .curveEaseIn, animations: {
                self.hiraganaDescriptionTextView.center.x = self.hiraganaDescriptionTextView.center.x - 50
                
            }){ (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.hiraganaDescriptionTextView.center.x = self.view.center.x - (self.view.center.x * 2)
                    self.hiraganaDescriptionTextView.alpha = 0.5
                })
            }
            
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
                self.katakanaDescriptionTextView.center.x = self.katakanaDescriptionTextView.center.x + 50
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.katakanaDescriptionTextView.center.x = self.view.center.x - (self.view.center.x * 2)
                    self.katakanaDescriptionTextView.alpha = 0.5
                })
            })
        }
        
    }
    
    func disableSunButton() {
        self.menuButtons.forEach({ (button) in
            button.isEnabled = false
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.menuButtons.forEach({ (button) in
                button.isEnabled = true
            })
        }
    }
    
    
    //shakes chracterview
    func shakeStudyStack() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.studyStack.center.x - 10, y: self.studyStack.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.studyStack.center.x + 10, y: self.studyStack.center.y))
        
        self.studyStack.layer.add(shakeAnimation, forKey: "position")
    }
    
    //fetch core data
    func fetchCoredata(){
        // Initialize Fetch Request\
        let fetchRequest: NSFetchRequest<Consonant> = Consonant.fetchRequest()
        // Add Specific type Descriptors
        fetchRequest.predicate = NSPredicate(format: "system == %@ OR system == %@", japaneseType.rawValue, yVowelJapanese.rawValue)
        // initializes showingCharacter
        self.showingCharacters = [:]
        do {
            let result = try self.coreDataStack.viewContext.fetch(fetchRequest)

            for item in result {
                guard let consonant = item.consonant else {return}
                if item.isUnlocked {
                    var characterList = [String]()
                    let words = item.words?.allObjects as? [WordLearnt]
                    guard let wordsLearnt = words else {return}
                    for wordLearnt in wordsLearnt {
                        if wordLearnt.confidenceCounter > 0 {
                            characterList.append(wordLearnt.word!)
                            characterDict[wordLearnt.word!] = wordLearnt
                        }
                    }
                    if characterList.count > 0 {
                        showingCharacters[consonant] = characterList
                        //sort letters
                        showingCharacters[consonant]!.sort()
                    }
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
            self.homeSunButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (_) in
            UIView.animate(withDuration: 0.12, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4, options: .curveLinear, animations: {
                self.homeSunButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        //When sun button is pressed, animate the pulsating layer
        if popCount == 0 {
            homeSunButton.animateShadow(pulsing: false, color: UIColor.redSun)
            animateSunButtonLabel(show: false)
            animatePulsatingLayer()
            homeSunButton.isEnabled = false
            popOutMenuButtons()
            popCount += 1
        } else {
            homeSunButton.animateShadow(pulsing: true, color: UIColor.redSun)
            animateSunButtonLabel(show: true)
            animatePulsatingLayer()
            homeSunButton.isEnabled = false
            popInMenuButtons()
            popCount -= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.homeSunButton.isEnabled = true
        }
    }
    
    func animateSunButtonLabel(show: Bool) {
        
        if show == true {
            homeSunButton.titleLabel?.alpha = 0
            UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .curveEaseInOut], animations: {
                self.homeSunButton.titleLabel?.alpha = 1
            }, completion: nil)
            
        } else {
        
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.homeSunButton.titleLabel?.alpha = 0
            }, completion: nil)
        }
        
    }
    
    @IBAction func studyButonTapped(_ sender: Any) {
        fetchCoredata()
        if !self.showingCharacters.isEmpty {
            let storyboard = UIStoryboard(name: "Speaking", bundle: .main)
            let showCharacterVC = storyboard.instantiateViewController(withIdentifier: "showCharactersVC") as! ShowCharactersViewController
            showCharacterVC.japaneseDictForRandom = self.showingCharacters
            showCharacterVC.japaneseType = self.japaneseType
            showCharacterVC.characterCoreDataDict = self.characterDict
            showCharacterVC.backgroundColor = self.backgroundColor
            showCharacterVC.transitioningDelegate = self
            transition.circleColor = studyButton.backgroundColor!
            showCharacterVC.modalPresentationStyle = .custom
            self.effects.sound(nil, nil, .stretch)
            present(showCharacterVC, animated: true, completion: nil)
        } else {
            shakeStudyStack()
            selectChallengeAlert()
        }
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
    
    
    //Menu Button Animations -----------------------------------------------------// 
    func popOutMenuButtons() {
        
        UIView.animate(withDuration: 1.5) {
            self.comboLabel.alpha = 1
            self.characterLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.125, options: .curveEaseInOut, animations: {
            self.characterStack.center.x = self.characterStack.center.x - 115
            self.effects.sound(.three, nil, nil)
            self.characterButton.animateShadow(pulsing: true, color: UIColor.materialBeige)
            self.characterButton.isEnabled = true
            
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.ComboStack.center.y = self.ComboStack.center.y - 125
                self.effects.sound(.two, nil, nil)
                self.comboButton.animateShadow(pulsing: true, color: UIColor.peach)
                self.comboButton.isEnabled = true
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.studyStack.center.x = self.studyStack.center.x + 115
                    self.effects.sound(.one, nil, nil)
                    self.studyButton.animateShadow(pulsing: true, color: UIColor.lavender)
                    self.studyButton.isEnabled = true
                }) { _ in
                    self.challengeLabel.alpha = 1
                }
            })
        }
        
        
    }
    
    func popInMenuButtons() {
        UIView.animate(withDuration: 0.2, delay: 0.125, options: .curveEaseInOut, animations: {
            self.studyStack.center.x = self.homeSunButton.center.x
            self.effects.sound(.backOne, nil, nil)
            self.studyButton.isEnabled = false
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.ComboStack.center.y = self.homeSunButton.center.y
                self.effects.sound(.backTwo, nil, nil)
                self.comboButton.isEnabled = false
            }, completion: { (_) in
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.characterStack.center.x = self.homeSunButton.center.x
                        self.effects.sound(.backThree, nil, nil)
                        self.characterButton.isEnabled = false
                }, completion: nil)
            })
        }
        
        UIView.animate(withDuration: 0.5) {
            self.challengeLabel.alpha = 0
            self.comboLabel.alpha = 0
            self.characterLabel.alpha = 0
        }
    }
    
    
    
    // transition animation
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        transition.startingPoint = homeSunButton.center
        
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "combo" {
            let japaneseCharactersCVC = segue.destination as! JapaneseCharactersCollectionViewController
            japaneseCharactersCVC.japaneseType = self.yVowelJapanese
            japaneseCharactersCVC.backgoundColor = self.backgroundColor
            japaneseCharactersCVC.transitioningDelegate = self
            transition.circleColor = comboButton.backgroundColor!
            japaneseCharactersCVC.modalPresentationStyle = .custom
            
            let usedBefore: Bool
            
            if self.japaneseType == .hiragana {
                usedBefore = UserDefaults.standard.bool(forKey: "UsedHiraganaCharacter")
            } else {
                usedBefore = UserDefaults.standard.bool(forKey: "UsedKatakanaCharacter")
            }
            
            if usedBefore {
                self.effects.sound(nil, nil, .stretch)
                self.present(japaneseCharactersCVC, animated: true, completion: nil)
            } else {
                selectCombinationsAlert(japaneseType: self.japaneseType, closure: {
                    self.effects.sound(nil, nil, .stretch)
                    self.present(japaneseCharactersCVC, animated: true, completion: nil)
                })
                if self.japaneseType == .hiragana {
                    UserDefaults.standard.set(true, forKey: "UsedHiraganaCharacter")
                } else {
                    UserDefaults.standard.set(true, forKey: "UsedKatakanaCharacter")
                }
            }
            
        } else if segue.identifier == "character" {
            let japaneseCharactersCVC = segue.destination as! JapaneseCharactersCollectionViewController
            japaneseCharactersCVC.japaneseType = self.japaneseType
            japaneseCharactersCVC.backgoundColor = self.backgroundColor
            japaneseCharactersCVC.transitioningDelegate = self
            transition.circleColor = characterButton.backgroundColor!
            japaneseCharactersCVC.modalPresentationStyle = .custom
            
            let usedBefore: Bool
            
            if self.japaneseType == .hiragana {
                usedBefore = UserDefaults.standard.bool(forKey: "UsedComboHiraganaCharacter")
            } else {
                usedBefore = UserDefaults.standard.bool(forKey: "UsedComboKatakanaCharacter")
            }
            
            if usedBefore {
                self.effects.sound(nil, nil, .stretch)
                self.present(japaneseCharactersCVC, animated: true, completion: nil)
            } else {
                selectCharactersAlert(japaneseType: self.japaneseType, closure: {
                    self.effects.sound(nil, nil, .stretch)
                    self.present(japaneseCharactersCVC, animated: true, completion: nil)
                })
                if self.japaneseType == .hiragana {
                    UserDefaults.standard.set(true, forKey: "UsedComboHiraganaCharacter")
                } else {
                    UserDefaults.standard.set(true, forKey: "UsedComboKatakanaCharacter")
                }
            }
        }
    }
}

