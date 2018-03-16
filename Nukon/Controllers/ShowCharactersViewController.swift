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
    case next = "tap next"
    case recap = "tap recap"
}

enum ButtonTitle {
    case start
    case hold
    case next
    case recap
}

enum Order {
    case orderly
    case randomly
}

class ShowCharactersViewController: UIViewController {
    
    //create pulse layer for when user guesses correctly
    var pulseLayer: CAShapeLayer!
    
    //MARK: - Propaties
    var backgroundColor: UIColor!
    
    //Mark: Sound Properties
    var effects = SoundEffects()
    
    //values to show characters
    var japaneseList: [Japanese]?
    var japaneseDict: [String: [String?]]?
    var japaneseDictForRandom: [String: [String]]?
    let instance = PosibilitiesDict.instance
    var posibilitiesDict = [String: [String]]()
    var posibilities = [String]()
    var japaneseType: JapaneseType!
    var soundAndLettersList = [(String, [String?])]()
    var vowels = JapaneseCharacters().vowelSounds
    var soundsList = JapaneseCharacters().soundsList
    var order: Order = .orderly
    
    var judgedShownCharacters = [String: [(String, Int)]]()
    
    //coredata management
    let coreDataStack = CoreDataStack.instance
    var characterCoreDataDict: [String: WordLearnt]!

    var shownCharacter = ""
    var soundType = ""
    var sound = ""
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var counter: Int = 0
    var totalNumberOfCharacter: Int = 0
    var judge = Judge.yet
    var comment = Comment.start
    var buttonTitle = ButtonTitle.start
    
    var buffer: AVAudioPCMBuffer!
    
    var shownCharacters = [(String, String, [String])]() //(sound, character, [posibilities])
    var currentNumber: Int = 1
    var recognitionIsEnd: Bool = true
    
    // values for voice recognization
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    @IBOutlet weak var characterView: UIView!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var notOkButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // create cancel or exit button, takes user back to overview screen
    @IBOutlet weak var cancelButton: UIButton!
    
    // image to be animated when user guesses correctly
    @IBOutlet weak var correctImage: UIImageView!
    
    // animate sparkle images when correct
    @IBOutlet weak var sparkleOne: UIImageView!
    @IBOutlet weak var sparkleTwo: UIImageView!
    
    
    @IBOutlet weak var characterButton: UIButton!
    
    @IBOutlet var judgeButtons: [UIButton]!
    
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
        
        if let japaneseList = self.japaneseList, let japaneseDict = self.japaneseDict {
            for japanese in japaneseList{
                if let letters = japaneseDict[japanese.sound] {
                    // create list of tuples ex.) ("vowel", [あ, い, う, え, お])
                    self.soundAndLettersList.append((japanese.sound, letters))
                }
            }
        } else if let japaneseDict = self.japaneseDictForRandom {
            self.order = .randomly
            for (consonant, letters) in japaneseDict {
                self.soundAndLettersList.append((consonant, letters))
            }
        }
        
        self.posibilitiesDict = instance.posibilitiesDict
        
        self.totalNumberOfCharacter = numberOfCharacters()
        // choose first chracter
        switch self.order {
            case .orderly:
                self.shownCharacter = orderCharacter()
            case .randomly:
                self.shownCharacter = randomCharacter()
        }
        
        self.updateLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            self.soundLabel.alpha = 1
            self.soundLabel.text = self.sound
            self.pulsate()
            self.effects.sound(nil, .right, nil)
            self.enableJudgeButtons()
//            let when = DispatchTime.now() + 1.5 // delay for the number of seconds
//            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                //stops recording
            self.nextCharacterButton.isEnabled = true
//            }
        case .wrong, .wait:
            self.soundLabel.alpha = 1
            self.soundLabel.text = self.sound
            self.characterButton.backgroundColor = .materialBeige
            self.shakeCharacter()
//            self.effects.sound(nil, .wrong)
            self.enableJudgeButtons()
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
        switch order {
        case .orderly:
            guard let japaneseDict = self.japaneseDict else {return 0}
            for value in japaneseDict.values {
                for character in value {
                    if character != nil {
                        numberOfCharacters += 1
                    }
                }
            }
        case .randomly:
            guard let japaneseDict = self.japaneseDictForRandom else {return 0}
            for value in japaneseDict.values {
                numberOfCharacters += value.count
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
        let vowelIndex = Int(arc4random()) % letters.count
        // picks a character with random numbers
        let showCharacter = letters[vowelIndex]
        let correntsound = sounds![vowelIndex]
        // picks a list of possible characters of the picked character
        self.posibilities = self.posibilitiesDict[correntsound]!
        self.sound = correntsound
        self.shownCharacters.append((correntsound, showCharacter!, self.posibilities))
        
        // deletes selected character
        self.soundAndLettersList[soundIndex].1.remove(at: vowelIndex)
        self.soundsList[sound]?.remove(at: vowelIndex)
        if self.soundAndLettersList[soundIndex].1.count == 0 {
            self.soundAndLettersList.remove(at: soundIndex)
        }
        print(soundAndLettersList)
        //updates currentNumber
        self.counter += 1
        self.currentNumber = self.counter
        return showCharacter!
        
    }
    
    func orderCharacter() -> String {
        // shows a character orderly
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
        self.soundType = soundAndLettersList[self.soundIndexCounter].0
        var vowel: String!
        switch numberOfCharactersInList {
        case 3:
            let index = self.vowelIndexCounter*2
            vowel = self.vowels[index]
        case 2:
            let index = self.vowelIndexCounter*4
            vowel = self.vowels[index]
        default:
            vowel = self.vowels[self.vowelIndexCounter]
        }
        self.vowelIndexCounter += 1
        self.counter += 1
        //makes correctsound
        var correctsound = ""
        if self.soundType == "Vowel" {
            correctsound = vowel
        } else if self.soundType == "Special-N" {
            correctsound = "n"
        } else {
            correctsound = soundType.lowercased() + vowel
        }
        self.posibilities = self.posibilitiesDict[correctsound]!
        self.sound = correctsound
        self.shownCharacters.append((correctsound, showCharacter, self.posibilities))
        //updates currentNumber
        self.currentNumber = self.counter
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
        textToSpeak.rate = 0.01
        textToSpeak.volume = 1.0
        //        let numberOfSeconds = 10.0
        //        textToSpeak.preUtteranceDelay = numberOfSeconds
        let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        let speak = AVSpeechSynthesizer()
        textToSpeak.voice = speakerVoice
        //        speak.delegate = self
        speak.speak(textToSpeak)
    }
    
    func soundAnimation() {
        self.soundLabel.alpha = 1
        self.soundLabel.text = self.sound
        
        let fadeout = {
            self.soundLabel.alpha = 0
        }
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: fadeout, completion: nil)
    }
    
    func enableJudgeButtons() {
        self.judgeButtons.forEach { button in
            button.alpha = 1
            button.isEnabled = true
        }
    }
    
    func unenableJudgeButtons() {
        self.judgeButtons.forEach { button in
            button.alpha = 0.5
            button.isEnabled = true
        }
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
        if counter == totalNumberOfCharacter {
            self.dismissView()
        } else {
            self.unenableJudgeButtons()
            switch self.order {
                case .orderly:
                    self.shownCharacter = orderCharacter()
                case .randomly:
                    self.shownCharacter = randomCharacter()
            }
            self.comment = .start
            self.buttonTitle = .start
            self.judge = .yet
            self.updateLabels()
            moveCharacter()
        }
    }
    
    func moveCharacter() {
        let animation = {
            
            let downwards = {
                self.characterButton.center.y = self.characterView.center.y + 35
                
            }
            
            UIView.animate(withDuration: 1.0, delay: 1.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: downwards, completion: nil)
            
            let upwards = {
                self.characterButton.center.y = self.characterButton.center.y - 35
            }
            
            UIView.animate(withDuration: 2.0, delay: 4.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: upwards, completion: nil)

        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: .curveEaseInOut, animations: animation, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func characterTapped(_ sender: Any) {
        speakJapanese(string: self.shownCharacter)
        if self.judge == .yet {
            soundAnimation()
        }
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        refreshTask()
        
        if self.currentNumber < self.totalNumberOfCharacter {
            if self.counter == self.currentNumber {
                self.soundLabel.text = ""
                self.shownCharacter = orderCharacter()
            } else {
                let nextNumber = self.currentNumber + 1
                self.sound = self.shownCharacters[nextNumber - 1].0
                self.shownCharacter = self.shownCharacters[nextNumber - 1].1
                self.posibilities = self.shownCharacters[nextNumber - 1].2
                self.currentNumber = nextNumber
            }
            self.judge = .yet
            self.comment = .start
            self.buttonTitle = .start
            self.updateLabels()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        refreshTask()
        
        if self.currentNumber > 1 {
            let backNumber = self.currentNumber - 1
            self.sound = self.shownCharacters[backNumber - 1].0
            self.shownCharacter = self.shownCharacters[backNumber - 1].1
            self.posibilities = self.shownCharacters[backNumber - 1].2
            self.currentNumber = backNumber
            self.comment = .start
            self.buttonTitle = .start
            self.judge = .yet
            self.updateLabels()
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
        case .recap:
            return
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
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
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
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let `self` = self else { return }
            
            var isFinal = false
            
            if let result = result {
                let previousBestString = theBestString
                self.commentLabel.text = Comment.recognizing.rawValue
                self.nextCharacterButton.isEnabled = false
                theBestString = result.bestTranscription.formattedString
                if theBestString != "" && previousBestString != "" {
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
                    
                    if willAppend {
                        if theBestString.count > 2 && !self.isAlpha(char: theBestString.first!) {
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
            self.buffer = buffer
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
