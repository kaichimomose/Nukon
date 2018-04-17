//
//  PracticeViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/09.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

enum Order {
    case orderly
    case randomly
}

protocol CharacterDelegate: class {
    func randomCharacter()
    func orderCharacter()
    func dismissPracticeView()
    func updateCoreData(confidence: Int)
    func animateInFirstWalkthrough()
    func backToOriginalView()
}

class PracticeViewController: UIViewController, CharacterDelegate {

    //MARK: - Properties
    let speakingCellReuseIdentifer = "SpeakingCell"
    let writingCellReuseIdentifer = "WritingCell"
    var backgroundColor: UIColor!
    
    var order: Order = .orderly
    
    var japaneseType: JapaneseType!
    var japaneseList: [Japanese]?
    var japaneseDict: [String: [String?]]?
    
    var soundAndLettersList = [(String, [String?])]()
    var soundsList = JapaneseCharacters.soundsList
    
    var shownCharacter = ""
    var sound = ""
    
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var totalNumberOfCharacter: Int = 0
    var currentNumber: Int = 0
    
    //coredata management
    let coreDataStack = CoreDataStack.instance
    var characterCoreDataDict: [String: WordLearnt]!
    
    //Bulr effect
    var effect: UIVisualEffect!
    var vcrEffect: UIVisualEffect!
    
    //Sound effect
    var effects = SoundEffects()
    
    //MARK: -Outlets
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    @IBOutlet weak var countCharactersLabel: UILabel!
    
    //MARK: Blur view and nested elements
    @IBOutlet var buttons: [UIButton]!
    
    //MARK: Confidence Walkthrough and Elements
    @IBOutlet weak var confidenceWalkthrough: UIVisualEffectView!
    @IBOutlet weak var exitWalkthrough: UIButton!
    
    //MARK: Voice Recognition Walkthrough and elements
    @IBOutlet weak var voiceRecognitionWalkthrough: UIVisualEffectView!
    @IBOutlet weak var redArrowOnVcrWalkthrough: UIImageView!
    @IBOutlet weak var voiceRecognitionButton: UIButton!
    @IBOutlet weak var exitSecondWalkthrough: Exit!
    
    //information button, intiates the walkthrough process
    @IBOutlet weak var information: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.backgroundColor
        
        menuBar.practiceVC = self
        menuBarCollectionView.delegate = menuBar
        menuBarCollectionView.dataSource = menuBar
        menuBarCollectionView.backgroundColor = self.backgroundColor
        
        let selectedIndexpath = NSIndexPath(row: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexpath as IndexPath, animated: false, scrollPosition: [])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(UINib.init(nibName: "SpeakingCell", bundle: .main), forCellWithReuseIdentifier: speakingCellReuseIdentifer)
        collectionView.register(UINib.init(nibName: "WritingCell", bundle: .main), forCellWithReuseIdentifier: writingCellReuseIdentifer)
        
        if let japaneseDict = self.japaneseDict {
            if let japaneseList = self.japaneseList {
                for japanese in japaneseList{
                    if let letters = japaneseDict[japanese.sound] {
                        // create list of tuples ex.) ("vowel", [あ, い, う, え, お])
                        self.soundAndLettersList.append((japanese.sound, letters))
                    }
                }
            } else {
                self.order = .randomly
                for (consonant, letters) in japaneseDict {
                    self.soundAndLettersList.append((consonant, letters))
                }
            }
        }
        
        self.totalNumberOfCharacter = numberOfCharacters()
        // choose first chracter
        switch self.order {
        case .orderly:
            
//            self.commentLabel.alpha = 0.0
//            self.nextCharacterButton.alpha = 0.0
//            self.nextCharacterButton.isEnabled = false
            
            orderCharacter()
        case .randomly:
            randomCharacter()
        }
        
        self.countCharactersLabel.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
        
        //Walkthrough blur For confidences
        confidenceWalkthrough.center = self.view.center
        confidenceWalkthrough.frame = self.view.frame
        confidenceWalkthrough.alpha = 0
        effect = confidenceWalkthrough.effect
        confidenceWalkthrough.effect = nil
        
        buttons.forEach { (button) in
            button.layer.cornerRadius = button.layer.frame.height/2
        }
        
        //Walkthrough buttons for voice recognition
        voiceRecognitionWalkthrough.center = self.view.center
        voiceRecognitionWalkthrough.frame = self.view.frame
        voiceRecognitionWalkthrough.alpha = 0
        exitSecondWalkthrough.blur = voiceRecognitionWalkthrough.effect
        voiceRecognitionWalkthrough.effect = nil
        exitSecondWalkthrough.dismissedView = voiceRecognitionWalkthrough
        voiceRecognitionButton.layer.cornerRadius = voiceRecognitionButton.layer.frame.width / 2
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let usedBefore = UserDefaults.standard.bool(forKey: "UsedBefore")
        
        if !usedBefore {
            self.menuBarCollectionView.isUserInteractionEnabled = false
            self.information.isEnabled = false
            self.information.alpha =  0.5
            switch self.japaneseType {
            case .hiragana, .yVowelHiragana:
                self.view.backgroundColor = UIColor.hiraganaDarkBackground
            default:
                self.view.backgroundColor = UIColor.katakanaDarkBackground
            }
        }
    }
    
    func scrollToItemIndexPath(menuindex: Int) {
        collectionView.reloadData()
        if menuindex == 1 {
            information.alpha = 0.5
            information.isEnabled = false
        } else {
            information.alpha = 1.0
            information.isEnabled = true
        }
        let indexPath = NSIndexPath(item: 0, section: menuindex)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
    func numberOfCharacters() -> Int {
        // return total number of characters that are in the list
        var numberOfCharacters = 0
        guard let japaneseDict = self.japaneseDict else {return 0}
        for value in japaneseDict.values {
            for character in value {
                if character != nil {
                    numberOfCharacters += 1
                }
            }
        }
        return numberOfCharacters
    }
    
    func randomCharacter() {
        // chooses a character randomly, returns it
        // generates random numbers
        let soundIndex = Int(arc4random()) % self.soundAndLettersList.count
        let (sound, letters) = self.soundAndLettersList[soundIndex]
        // gets sounds
        var sounds = soundsList[sound]
        print(sounds!)
        let vowelIndex = Int(arc4random()) % letters.count
        // picks a character with random numbers
        print(soundIndex, vowelIndex)
        let character = letters[vowelIndex]
        if let showCharacter = character {
            let currectsound = sounds![vowelIndex]
            print(currectsound)
            // picks a list of possible characters of the picked character
            self.sound = currectsound
            
            // deletes selected character
            self.soundAndLettersList[soundIndex].1.remove(at: vowelIndex)
            self.soundsList[sound]?.remove(at: vowelIndex)
            if self.soundAndLettersList[soundIndex].1.count == 0 {
                self.soundAndLettersList.remove(at: soundIndex)
            }
            print(soundAndLettersList)
            //updates currentNumber
            self.currentNumber += 1
            self.shownCharacter = showCharacter
            self.countCharactersLabel.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
            self.collectionView.reloadData()
        } else {
            // deletes selected character
            self.soundAndLettersList[soundIndex].1.remove(at: vowelIndex)
            self.soundsList[sound]?.remove(at: vowelIndex)
            if self.soundAndLettersList[soundIndex].1.count == 0 {
                self.soundAndLettersList.remove(at: soundIndex)
            }
            randomCharacter()
        }
    }
    
    // shows a character orderly
    func orderCharacter() {
        
        let numberOfCharactersInList = soundAndLettersList[self.soundIndexCounter].1.count
        if self.vowelIndexCounter == numberOfCharactersInList {
            self.vowelIndexCounter = 0
            self.soundIndexCounter += 1
            if self.soundIndexCounter == soundAndLettersList.count {
                self.vowelIndexCounter = 0
                self.soundIndexCounter = 0
            }
        }
        let character = soundAndLettersList[self.soundIndexCounter].1[self.vowelIndexCounter]
        if let showCharacter = character {
            let soundType = soundAndLettersList[self.soundIndexCounter].0
            //makes correctsound
            let currectsound = soundsList[soundType]![self.vowelIndexCounter]
            print(currectsound)
            
            self.vowelIndexCounter += 1
            
            self.sound = currectsound
            
            //updates currentNumber
            self.currentNumber += 1
            self.shownCharacter = showCharacter
            self.countCharactersLabel.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
            self.collectionView.reloadData()
        }else {
            self.vowelIndexCounter += 1
            orderCharacter()
        }
    }
    
    func dismissPracticeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateCoreData(confidence: Int) {
        let word = characterCoreDataDict[self.shownCharacter]
        guard let wordLearnt = word else {return}
        let backgroundEntity = coreDataStack.privateContext.object(with: wordLearnt.objectID) as! WordLearnt
        backgroundEntity.confidenceCounter = Int16(confidence)
        coreDataStack.saveTo(context: coreDataStack.privateContext)
        coreDataStack.viewContext.refresh(wordLearnt, mergeChanges: true)
    }
    
    func varticalDot() -> CAShapeLayer {
        let lineDashPattern: [NSNumber] = [10, 5]
        let varticalShapeLayer = CAShapeLayer()
        varticalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        varticalShapeLayer.lineWidth = 2
        varticalShapeLayer.lineDashPattern = lineDashPattern
        let varticalpath = CGMutablePath()
        let length = UIScreen.main.bounds.width - 80
        varticalpath.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: 0, y: length)])
        varticalShapeLayer.path = varticalpath
        return varticalShapeLayer
    }
    
    func horisontalDot() -> CAShapeLayer {
        let lineDashPattern: [NSNumber] = [10, 5]
        let horisontalShapeLayer = CAShapeLayer()
        horisontalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        horisontalShapeLayer.lineWidth = 2
        horisontalShapeLayer.lineDashPattern = lineDashPattern
        let horisontalpath = CGMutablePath()
        let length = UIScreen.main.bounds.width - 80
        horisontalpath.addLines(between: [CGPoint(x: 0, y: 0),
                                          CGPoint(x: length, y: 0)])
        horisontalShapeLayer.path = horisontalpath
        
        return horisontalShapeLayer
    }
    
    //MARK: - Animations
    //delegation
    func animateInFirstWalkthrough() {
        self.view.addSubview(confidenceWalkthrough)
        
        confidenceWalkthrough.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.effects.swooshResource(.water)
            
            self.confidenceWalkthrough.effect = self.effect
            self.confidenceWalkthrough.alpha = 1
            self.confidenceWalkthrough.isHidden = false
            self.confidenceWalkthrough.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func animateInSecondeWalkthrough() {
        self.view.addSubview(voiceRecognitionWalkthrough)
        
        voiceRecognitionWalkthrough.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.effects.swooshResource(.water)
            self.voiceRecognitionWalkthrough.effect = self.effect
            self.voiceRecognitionWalkthrough.alpha = 1
            self.voiceRecognitionWalkthrough.isHidden = false
            self.voiceRecognitionWalkthrough.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            self.voiceRecognitionButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { (_) in
            
            UIView.animate(withDuration: 0.7, delay: 1.0, usingSpringWithDamping: 4, initialSpringVelocity: 7, options: .curveEaseOut, animations: {
                self.voiceRecognitionButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
    
    //delegation
    func backToOriginalView() {
        //make imformation button enable
        self.information.isEnabled = true
        self.information.alpha =  1
        self.menuBarCollectionView.isUserInteractionEnabled = true
        self.view.backgroundColor = self.backgroundColor
    }
    
    
    //MARK: - Actions
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismissPracticeView()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        animateInFirstWalkthrough()
    }
    
    @IBAction func exitFirstWalkthrough(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.confidenceWalkthrough.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.confidenceWalkthrough.effect = nil
            self.confidenceWalkthrough.alpha = 0
        }) { (_) in
            self.confidenceWalkthrough.removeFromSuperview()
            self.animateInSecondeWalkthrough()
        }
    }
    
}

extension PracticeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: speakingCellReuseIdentifer, for: indexPath) as! SpeakingCell
            cell.delegate = self
            cell.backgroundColor = self.backgroundColor
            cell.originalBackgroundColor = self.backgroundColor
            cell.shownCharacter = self.shownCharacter
            cell.sound = self.sound
            cell.order = self.order
            cell.currentNumber = self.currentNumber
            cell.totalNumberOfCharacter = self.totalNumberOfCharacter
            cell.judge = Judge.yet
            cell.comment = Comment.start
            cell.buttonTitle = ButtonTitle.start
            
            let usedBefore = UserDefaults.standard.bool(forKey: "UsedBefore")
            if !usedBefore {
                cell.commentLabel.alpha = 0
                
                cell.characterView.backgroundColor = self.backgroundColor
                
                switch self.japaneseType {
                case .hiragana, .yVowelHiragana:
                    cell.backgroundColor = UIColor.hiraganaDarkBackground
                default:
                    cell.backgroundColor = UIColor.katakanaDarkBackground
                }
            }
            
            cell.updateLabels()
            cell.moveCharacter()
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: writingCellReuseIdentifer, for: indexPath) as! WritingCell
            cell.delegate = self
            cell.backgroundColor = self.backgroundColor
            cell.japaneseType = self.japaneseType
            cell.shownCharacter = self.shownCharacter
            cell.sound = self.sound
            cell.order = self.order
            cell.currentNumber = self.currentNumber
            cell.totalNumberOfCharacter = self.totalNumberOfCharacter
            cell.judge = Judge.yet
            cell.varticalDottedLine.layer.addSublayer(varticalDot())
            cell.horizontalDottedLine.layer.addSublayer(horisontalDot())
            cell.updateLabels()
            return cell
        }
    }
}
