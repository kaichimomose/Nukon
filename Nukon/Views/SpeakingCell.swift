//
//  SpeakingCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/09.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

enum Judge {
    case correct
    case wrong
    case wait
    case yet
}

enum Comment: String {
    case start = "Hold button to record"
    case recording = "Recording, say just once"
    case recognizing = "Recognizing"
    case again = "Record again"
}

enum ButtonTitle {
    case start
    case hold
    case next
}


class SpeakingCell: UICollectionViewCell {
    
    //MARK: - Properties
    var originalBackgroundColor: UIColor?
    var shownCharacter: String!
    var totalNumberOfCharacter: Int!
    var currentNumber: Int!
    
    let posibilitiesDict = PosibilitiesDict.posibilitiesDict
    var posibilities = [String]()
    
    var soundAndLettersList = [(String, [String?])]()
    var soundsList = JapaneseCharacters.soundsList
    
    var sound: String! {
        didSet {
            posibilities = posibilitiesDict[sound]!
        }
    }
    
    var apperOnce = false
    
    var order: Order! {
        didSet {
            if order == .orderly {
                if !apperOnce {
                    self.commentLabel.alpha = 0.0
                    self.nextCharacterButton.alpha = 0.0
                    self.nextCharacterButton.isEnabled = false
                    apperOnce = true
                }
            }
        }
    }
    
    var judge = Judge.yet
    var comment = Comment.start
    var buttonTitle = ButtonTitle.start
    
    //Sound Properties
    var effects = SoundEffects()
    
    // values for voice recognization
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var recognitionIsEnd: Bool = true
    
    //delegation
    weak var delegate: CharacterDelegate!

    //MARK: - Outlets
    @IBOutlet weak var characterButton: UIButton!
    @IBOutlet weak var characterView: UIView!
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBOutlet var confortLevelButtons: [UIButton]!
    @IBOutlet weak var confatableLevel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var nextCharacterButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var recordButtonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.characterButton.layer.cornerRadius = 10
        self.characterButton.layer.shadowColor = UIColor.materialBeige.cgColor
        self.characterButton.layer.shadowRadius = 15
        self.characterButton.layer.shadowOpacity = 0.7
        
        self.nextCharacterButton.layer.cornerRadius = self.nextCharacterButton.frame.width / 2
        
        self.confortLevelButtons.forEach { button in
            button.layer.cornerRadius = button.frame.size.height/2
        }
        
        self.disableJudgeButtons()

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
    
    func enableJudgeButtons() {
        self.confatableLevel.alpha = 1
        self.confortLevelButtons.forEach { button in
            button.transform = CGAffineTransform.identity
            button.alpha = 1
            button.isEnabled = true
        }
    }
    
    func disableJudgeButtons() {
        self.confatableLevel.alpha = 0
        self.confortLevelButtons.forEach { button in
            //            button.transform = CGAffineTransform(scaleX: 0, y: 0)
            button.alpha = 0.0
            button.isEnabled = false
        }
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
            self.nextCharacterButton.isEnabled = true
        case .yet:
            self.soundLabel.text = ""
            self.characterButton.backgroundColor = .materialBeige
        }
        
    }
    
    //MARK: - Animations
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
    
    func fadeInJudgeButtons() {
        let enable = {
            self.enableJudgeButtons()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: [.curveEaseInOut, .allowUserInteraction], animations: enable, completion: nil)
    }
    
    func fadeOutJudgeButtons() {
        let unenable = {
            self.disableJudgeButtons()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: unenable, completion: nil)
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
    
    func dismissView() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        delegate.dismissPracticeView()
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
                
                delegate.orderCharacter()
            default:
                delegate.randomCharacter()
            }
            self.fadeOutJudgeButtons()
            moveCharacter()
        }
    }
    
    func animateOnboard() {
        let onboardAnimation = {
            self.characterView.backgroundColor = .clear
            
            self.confatableLevel.alpha = 1
            self.buttonsView.backgroundColor = self.originalBackgroundColor
            
            self.commentLabel.alpha = 1
            self.recordButtonView.backgroundColor = self.originalBackgroundColor
            self.nextCharacterButton.alpha = 1
            
            self.confortLevelButtons.forEach { button in
                button.alpha = 1
            }
        }
        
        UIView.animate(withDuration: 1.0, delay: 3.5, options: [], animations: onboardAnimation, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.buttonsView.backgroundColor = .clear
            self.recordButtonView.backgroundColor = .clear
            
            self.backgroundColor = self.originalBackgroundColor
            
            //make buttons enable
            self.nextCharacterButton.isEnabled = true
            self.enableJudgeButtons()
            
            //show FirstWalkThrough 
            self.delegate.animateInFirstWalkthrough()
            
            //change superview backgroundcolor
            self.delegate.backToOriginalView()
            
            //updata userdefalt "UsedBefore" ture
            UserDefaults.standard.set(true, forKey: "UsedBefore")
        })
    }
    
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
            self.animateOnboard()
        } else {
            if self.order == .orderly {
                
                self.commentLabel.alpha = 1
                self.nextCharacterButton.alpha = 1
                self.nextCharacterButton.isEnabled = true
                
                fadeInJudgeButtons()
            }
        }
    }

    @IBAction func redButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 0)
        self.dissmissOrNextCharacter()
    }
    
    
    @IBAction func orangeButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 1)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 2)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func limeButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 3)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 4)
        self.dissmissOrNextCharacter()
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
}

extension SpeakingCell: SFSpeechRecognizerDelegate {
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
