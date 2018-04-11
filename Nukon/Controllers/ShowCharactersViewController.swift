//
//  ShowCharactersViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/30.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import CoreData.NSFetchedResultsController
import Speech

class ShowCharactersViewController: UIViewController {
    
    //create pulse layer for when user guesses correctly
    var pulseLayer: CAShapeLayer!
    
    //MARK: - Properties
    weak var backgroundColor: UIColor!
    
    //Sound Properties
    var effects = SoundEffects()
    
    //values to show characters
    var japaneseType: JapaneseType!
    
    var japaneseList: [Japanese]?
    var japaneseDict: [String: [String?]]?
    
    let posibilitiesDict = PosibilitiesDict.posibilitiesDict
    var posibilities = [String]()
    
    var soundAndLettersList = [(String, [String?])]()
    var soundsList = JapaneseCharacters.soundsList
    var order: Order = .orderly
    
    var shownCharacter = ""
    var sound = ""
    
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var totalNumberOfCharacter: Int = 0
    
    var judge = Judge.yet
    var comment = Comment.start
    var buttonTitle = ButtonTitle.start
    
    //coredata management
    let coreDataStack = CoreDataStack.instance
    var characterCoreDataDict: [String: WordLearnt]!
    
    var currentNumber: Int = 0
    
    // values for voice recognization
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var recognitionIsEnd: Bool = true
    
    //MARK: Blur view and nested elements
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var orangeButton: UIButton!
    
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var limeButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    
    
    //MARK: Confidence Walkthrough and Elements
    @IBOutlet weak var confidenceWalkthrough: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    
    @IBOutlet weak var exitWalkthrough: UIButton!
    
    
    //MARK: Voice Recognition Walkthrough and elements
    @IBOutlet var voiceRecognitionWalkthrough: UIVisualEffectView!
    
    var vcrEffect: UIVisualEffect!
    
    @IBOutlet weak var redArrowOnVcrWalkthrough: UIImageView!
    
    @IBOutlet weak var voiceRecognitionButton: UIButton!
    
    @IBOutlet weak var exitSecondWalkthrough: Exit!
    
    @IBOutlet weak var characterView: UIView!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBOutlet weak var notOkButton: UIButton!
    @IBOutlet weak var notBadButton: UIButton!
    @IBOutlet weak var sosoButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    
    @IBOutlet weak var confatableLevel: UILabel!
    
    // create cancel or exit button, takes user back to overview screen
    @IBOutlet weak var cancelButton: UIButton!
    
    //information button, intiates the walkthrough process
    @IBOutlet weak var information: UIButton!
    
    @IBOutlet weak var characterButton: UIButton!
    
    @IBOutlet var judgeButtons: [UIButton]!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var recordButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.backgroundColor
        
        speechRecognizer.delegate = self
        
        self.characterButton.layer.cornerRadius = 10
        self.characterButton.layer.shadowColor = UIColor.materialBeige.cgColor
        self.characterButton.layer.shadowRadius = 15
        self.characterButton.layer.shadowOpacity = 0.7
        
        self.nextCharacterButton.layer.cornerRadius = self.nextCharacterButton.frame.width / 2
        
        self.judgeButtons.forEach { button in
            button.layer.cornerRadius = button.frame.size.height/2
        }
        
        self.unenableJudgeButtons()
        
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
                
                self.commentLabel.alpha = 0.0
                self.nextCharacterButton.alpha = 0.0
                self.nextCharacterButton.isEnabled = false
                
                self.shownCharacter = orderCharacter()
            case .randomly:
                self.shownCharacter = randomCharacter()
        }
        
        self.updateLabels()
        
        //Walkthrough blur For confidences
        confidenceWalkthrough.center = self.view.center
        confidenceWalkthrough.frame = self.view.frame
        
        confidenceWalkthrough.alpha = 0
        
        effect = confidenceWalkthrough.effect
        
        confidenceWalkthrough.effect = nil
        
        
        //Color buttons information view setting
        let blurColorButtons = [redButton, orangeButton, yellowButton, limeButton, greenButton]
        
        blurColorButtons.forEach { (button) in
            button?.layer.cornerRadius = (button?.layer.frame.height)! / 2
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
        let usedBefore = UserDefaults.standard.bool(forKey: "UsedBefore")
        
        if !usedBefore {
            self.information.isEnabled = false
            self.information.alpha =  0.5
            self.commentLabel.alpha = 0
            
            self.characterView.backgroundColor = self.backgroundColor
            
            switch self.japaneseType {
            case .hiragana, .yVowelHiragana:
                self.view.backgroundColor = UIColor.hiraganaDarkBackground
            default:
                self.view.backgroundColor = UIColor.katakanaDarkBackground
            }
        }
        
        self.moveCharacter()
    }
    
    func updateLabels() {
        // updates all labels
        self.commentLabel.text = self.comment.rawValue
        self.characterButton.setTitle(self.shownCharacter, for: .normal)
        if self.shownCharacter.count > 1 {
            self.characterButton.titleLabel?.font = self.characterButton.titleLabel?.font.withSize(100)
        } else {
            self.characterButton.titleLabel?.font = self.characterButton.titleLabel?.font.withSize(125)
        }
        self.countCharacters.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
        switch self.judge {
        case .correct:
            self.characterButton.isEnabled = false
            self.soundLabel.alpha = 1
            self.soundLabel.text = self.sound
            //color animation
            self.pulsate()
            //sound animation
            self.effects.sound(nil, .right, nil)
            self.fadeInJudgeButtons()
            let when = DispatchTime.now() + 2.0 // delay for the number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // code with delay
                //makes characterbutton enable
                self.characterButton.isEnabled = true
            }
            self.nextCharacterButton.isEnabled = true
        case .wrong, .wait:
            self.soundLabel.alpha = 1
            self.soundLabel.text = self.sound
            self.characterButton.backgroundColor = .materialBeige
            self.shakeCharacter()
            self.fadeInJudgeButtons()
//            let when = DispatchTime.now() + 2 // delay for the number of seconds
//            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                //stops recording
            self.nextCharacterButton.isEnabled = true
//            }
        case .yet:
            self.soundLabel.text = ""
            self.characterButton.backgroundColor = .materialBeige
        }

    }
    
    //animation when character guesses correctly
    func pulsate() {
        let pulseAnimation = CABasicAnimation(keyPath: "backgroundColor")
        let scaleUpAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.5
        scaleUpAnimation.duration = 0.5
//        pulseAnimation.repeatCount = 1
        
//        shakeAnimation.autoreverses = true
        pulseAnimation.autoreverses = true
        scaleUpAnimation.autoreverses = true
        
        scaleUpAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        pulseAnimation.toValue = UIColor.materialGreen.cgColor
        scaleUpAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        
        self.characterButton.layer.add(pulseAnimation, forKey: "backgroundColor")
        self.characterButton.layer.add(scaleUpAnimation, forKey: "transform")
        
    }
    
    //shakes chracterview
    func shakeCharacter() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.characterView.center.x - 10, y: self.characterView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.characterView.center.x + 10, y: self.characterView.center.y))
        
        self.characterView.layer.add(shakeAnimation, forKey: "position")
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
    
    func randomCharacter() -> String {
        // chooses a character randomly, returns it
        // generates random numbers
        let soundIndex = Int(arc4random()) % self.soundAndLettersList.count
        let (sound, letters) = self.soundAndLettersList[soundIndex]
        // gets sounds
        var sounds = soundsList[sound]
        print(sounds!)
        let vowelIndex = Int(arc4random()) % letters.count
        // picks a character with random numbers
        print(vowelIndex)
        let character = letters[vowelIndex]
        guard let showCharacter = character else {
            // deletes selected character
            self.soundAndLettersList[soundIndex].1.remove(at: vowelIndex)
            self.soundsList[sound]?.remove(at: vowelIndex)
            if self.soundAndLettersList[soundIndex].1.count == 0 {
                self.soundAndLettersList.remove(at: soundIndex)
            }
            return randomCharacter()
        }
        let currectsound = sounds![vowelIndex]
        print(currectsound)
        // picks a list of possible characters of the picked character
        self.posibilities = self.posibilitiesDict[currectsound]!
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
        return showCharacter
        
    }
    
    // shows a character orderly
    func orderCharacter() -> String {
        
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
        guard let showCharacter = character else {
            self.vowelIndexCounter += 1
            return orderCharacter()
        }
        let soundType = soundAndLettersList[self.soundIndexCounter].0
        //makes correctsound
        let currectsound = soundsList[soundType]![self.vowelIndexCounter]
        print(currectsound)
        
        self.vowelIndexCounter += 1
        
        self.posibilities = self.posibilitiesDict[currectsound]!
        print(posibilities)
        self.sound = currectsound
        
        //updates currentNumber
        self.currentNumber += 1
        return showCharacter
    }
    
    func isAlpha(char: Character) -> Bool {
        switch char {
        case "a"..."z":
            return true
        case "A"..."Z":
            return true
        default:
            return false
        }
    }
    
    func updateCoreData(confidence: Int) {
        let word = characterCoreDataDict[self.shownCharacter]
        guard let wordLearnt = word else {return}
        let backgroundEntity = coreDataStack.privateContext.object(with: wordLearnt.objectID) as! WordLearnt
        backgroundEntity.confidenceCounter = Int16(confidence)
        coreDataStack.saveTo(context: coreDataStack.privateContext)
        coreDataStack.viewContext.refresh(wordLearnt, mergeChanges: true)
    }
    
    func speakJapanese(string: String) {
        let textToSpeak = AVSpeechUtterance(string: string)
        textToSpeak.rate = 0.001
//        textToSpeak.volume = 1.0
        let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        let speak = AVSpeechSynthesizer()
        textToSpeak.voice = speakerVoice
        speak.speak(textToSpeak)
    }
    
    func soundAnimation() {
        self.soundLabel.alpha = 1
        self.soundLabel.text = self.sound
        
         if order == .randomly {
        
            let fadeout = {
                self.soundLabel.alpha = 0
            }

            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: fadeout, completion: nil)
        }
    }
    
    func enableJudgeButtons() {
        self.confatableLevel.alpha = 1
        self.judgeButtons.forEach { button in
            button.transform = CGAffineTransform.identity
            button.alpha = 1
            button.isEnabled = true
        }
    }
    
    func unenableJudgeButtons() {
        self.confatableLevel.alpha = 0
        self.judgeButtons.forEach { button in
//            button.transform = CGAffineTransform(scaleX: 0, y: 0)
            button.alpha = 0.0
            button.isEnabled = false
        }
    }
    
    
    func fadeInJudgeButtons() {
        let enable = {
            self.enableJudgeButtons()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: [.curveEaseInOut, .allowUserInteraction], animations: enable, completion: nil)
    }
    
    func fadeOutJudgeButtons() {
        let unenable = {
            self.unenableJudgeButtons()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: unenable, completion: nil)
    }
    
    func dismissView() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func dissmissOrNextCharacter(){
        refreshTask()
        if currentNumber == totalNumberOfCharacter {
            self.dismissView()
        } else {
            switch self.order {
                case .orderly:
                    
                    self.commentLabel.alpha = 0.0
                    self.nextCharacterButton.alpha = 0.0
                    self.nextCharacterButton.isEnabled = false
                    
                    self.shownCharacter = orderCharacter()
                case .randomly:
                    self.shownCharacter = randomCharacter()
            }
            self.fadeOutJudgeButtons()
            self.comment = .start
            self.buttonTitle = .start
            self.judge = .yet
            self.updateLabels()
            moveCharacter()
        }
    }
    
    func moveCharacter() {
        let animation = {
            //move downwards
            let downwards = {
                self.characterButton.center.y = self.characterView.center.y + 35
                self.soundLabel.center.y = self.soundLabel.center.y + 35
            }
            
            UIView.animate(withDuration: 1.0, delay: 1.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: [.curveEaseInOut, .allowUserInteraction], animations: downwards, completion: nil)
            
            //move upwards
            let upwards = {
                self.characterButton.center.y = self.characterButton.center.y - 35
                self.soundLabel.center.y = self.soundLabel.center.y - 35
            }
            
            UIView.animate(withDuration: 2.0, delay: 4.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: [.curveEaseInOut, .allowUserInteraction], animations: upwards, completion: nil)

        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: [.curveEaseInOut, .allowUserInteraction], animations: animation, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func characterTapped(_ sender: Any) {
        //stop animation
        self.characterButton.layer.removeAllAnimations()
        self.soundLabel.layer.removeAllAnimations()
        
        speakJapanese(string: self.shownCharacter)
        if self.judge == .yet {
            soundAnimation()
        }
        
        let usedBefore = UserDefaults.standard.bool(forKey: "UsedBefore")
        if !usedBefore {
            let onboardAnimation = {
                self.characterView.backgroundColor = .clear
                
                self.confatableLevel.alpha = 1
                self.buttonsView.backgroundColor = self.backgroundColor
                
                self.commentLabel.alpha = 1
                self.recordButtonView.backgroundColor = self.backgroundColor
                self.nextCharacterButton.alpha = 1
                
                self.judgeButtons.forEach { button in
                    button.alpha = 1
                }
            }
            
            UIView.animate(withDuration: 1.0, delay: 3.5, options: [], animations: onboardAnimation, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.buttonsView.backgroundColor = .clear
                self.recordButtonView.backgroundColor = .clear
                
                self.view.backgroundColor = self.backgroundColor
                
                //make imformation button enable
                self.information.isEnabled = true
                self.information.alpha =  1
                
                //make buttons enable
                self.nextCharacterButton.isEnabled = true
                self.enableJudgeButtons()
                
                self.animateInFirstWalkthrough()
                //TODO: updata userdefalt "UsedBefore" ture
                UserDefaults.standard.set(true, forKey: "UsedBefore")
            })
        } else {
            if self.order == .orderly {
                
                self.commentLabel.alpha = 1
                self.nextCharacterButton.alpha = 1
                self.nextCharacterButton.isEnabled = true
                
                fadeInJudgeButtons()
            }
        }
    }
    
    func squeezeIn() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nextCharacterButton.transform = CGAffineTransform(scaleX: 0.91, y: 0.91)
        })
    }
    
    func releaseButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.nextCharacterButton.transform = CGAffineTransform.identity
        })
    }
    
    @IBAction func buttonDown(_ sender: UIButton) {
        switch buttonTitle {
        case .next:
            return
        case .start:
            squeezeIn()
            if !audioEngine.isRunning {
                //if recoginitionIsEnd is true, call startRecording
                if recognitionIsEnd {
                    try! startRecording()
                    recognitionIsEnd = false
                }
                //start audio engine and recording
                try! startAudioEngine()
            }
            self.buttonTitle = .hold
            self.comment = .recording
        case .hold:
            self.comment = .start
            self.buttonTitle = .start
        }
        self.judge = .yet
        self.updateLabels()
    }
    
    @IBAction func buttonUp(_ sender: UIButton) {
        if self.audioEngine.isRunning {
            let when = DispatchTime.now() + 1 // delay for the number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                //stops recording
                self.audioEngine.stop()
                if self.comment != .again {
                    self.comment = .start
                }
                self.updateLabels()
            }
        }
        releaseButton()
        self.buttonTitle = .start
//        self.updateLabels()
    }
    
    @IBAction func notOkButtonTapped(_ sender: Any) {
        self.updateCoreData(confidence: 0)
        self.dissmissOrNextCharacter()
    }
    
    
    @IBAction func orangeButtonTapped(_ sender: Any) {
        self.updateCoreData(confidence: 1)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func middleButtonTapped(_ sender: Any) {
        self.updateCoreData(confidence: 2)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        self.updateCoreData(confidence: 3)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func goodButtonTapped(_ sender: Any) {
        self.updateCoreData(confidence: 4)
        self.dissmissOrNextCharacter()
    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.cancelButton.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.cancelButton.transform = CGAffineTransform.identity
            })
            self.dismissView()
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        animateInFirstWalkthrough()
    }
    
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

extension ShowCharactersViewController: SFSpeechRecognizerDelegate {
    // delegate called when availability of voice recognition is changed
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            nextCharacterButton.isEnabled = true
            self.buttonTitle = .start
        } else {
            nextCharacterButton.isEnabled = false
        }
    }
    
    private func startRecording() throws {
        refreshTask()
        
        let audioSession = AVAudioSession.sharedInstance()
        // sets category for record
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // the flag that decide whether request is made before compliting recording
        // true: shows a result of current request (現在-1回目のリクエスト結果が返ってくる)
        // false: shows a result of the final request (ボタンをオフにしたときに音声認識の結果が返ってくる)
        recognitionRequest.shouldReportPartialResults = true
        
        var willAppend = true
        var theBestString = ""
        var appendedString = ""
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [unowned self] result, error in
            
            var isFinal = false
            
            if let result = result {
                let previousBestString = theBestString
                self.commentLabel.text = Comment.recognizing.rawValue
                self.nextCharacterButton.isEnabled = false
                theBestString = result.bestTranscription.formattedString
                //gets new appended character
                if theBestString.count > previousBestString.count && theBestString != "" && previousBestString != "" {
                    let index = theBestString.index(theBestString.startIndex, offsetBy: previousBestString.count)
                    appendedString = String(theBestString[index...])
                    print(appendedString)
                }
//                print(self.shownCharacter + ": " + theBestString)
                if willAppend {
                    // passes first result
                    for posibility in self.posibilities {
                        if theBestString == posibility || appendedString == posibility{
                            print("the appended chara..." + self.shownCharacter + ": " + theBestString)
                            self.judge = .correct
                            
                            willAppend = false
                            recognitionRequest.shouldReportPartialResults = false
                            recognitionRequest.endAudio()
                            self.recognitionIsEnd = true
                            break
                        }
                    }
                    print(theBestString.count)
                    if willAppend {
                        if theBestString.count > 2 {
                            self.judge = .wrong
                            
                            willAppend = false
                            recognitionRequest.shouldReportPartialResults = false
                            recognitionRequest.endAudio()
                            self.recognitionIsEnd = true
                        } else {
                            self.judge = .wait
                            self.comment = .again
                        }
                    }
                }

                isFinal = result.isFinal
                print(isFinal)
                print(theBestString)
            } else {
                // stop recording
                self.audioEngine.stop()
                recognitionRequest.endAudio()
                self.recognitionIsEnd = true
                self.comment = .start
                self.buttonTitle = .start
                self.updateLabels()
            }
            
            // error handle and the handle after getting final result
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recognitionIsEnd = true
                
                if error != nil {
                    if self.judge == .wait {
                        self.judge = .yet
                    }
                }
                
                if self.judge == .wrong {
                    self.comment = .again
                } else {
                    self.comment = .start
                }
                self.buttonTitle = .start
                self.updateLabels()
            }
        }
        
        // give an buffer from microphone to the request
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        
//        try startAudioEngine()
    }
    
    private func refreshTask() {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
    
    private func startAudioEngine() throws {
        // prepare resource before starting
        audioEngine.prepare()
        
        try audioEngine.start()
    }
}
