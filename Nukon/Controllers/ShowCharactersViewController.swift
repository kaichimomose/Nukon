//
//  ShowCharactersViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/30.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import Speech

enum Judge: String {
    case correct = "✔️"
    case wrong = "✖️"
    case wait = "w"
    case yet = ""
}

enum Comment: String {
    case start = "Hold red button to record"
    case recording = "Recording, say just once"
    case recognizing = "Recognizing"
    case again = "Record again"
    case next = "tap next"
    case recap = "tap recap"
}

enum ButtonTitle: String {
    case start = "Start recording"
    case hold = ""
    case next = "Next Character"
    case recap = "See Recap"
}

class ShowCharactersViewController: UIViewController {
    
    //values to show characters
    var list = [Japanese]()
    var vowelSounds = [[String]]()
    var japaneseType: JapaneseType!
    var showingStyle: ShowingStyle!
    var shownCharacter = ""
    var soundType = ""
    var sound = ""
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var counter: Int = 0
    var totalNumberOfCharacter: Int = 0
    var mutableList = [(String, [String])]()
    var judge = Judge.yet
    var comment = Comment.start
    var buttonTitle = ButtonTitle.start
    
    var buffers = [AVAudioPCMBuffer]()
    var buffer: AVAudioPCMBuffer!
    
    var shownCharacters = [(String, String, [String])]() //(sound, character, [posibilities])
    var judgedShownCharacters = [String: (Judge, String)]() //(judge, soundType)
    var currentNumber: Int = 1
    var recognitionIsEnd: Bool = true
    
    var posibilitiesList = [Posibilities]()
    var posibilities = [String]()
    var mutablePosibilitiesList = [[[String]]]()
    
    // values for voice recognization
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var judgeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer.delegate = self
        
        self.characterLabel.layer.cornerRadius = 6
        self.characterLabel.layer.masksToBounds = true
        self.characterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.characterLabel.layer.borderWidth = 1
        
        self.nextCharacterButton.layer.cornerRadius = self.nextCharacterButton.frame.width / 2
        self.nextCharacterButton.layer.borderColor = UIColor.black.cgColor
        self.nextCharacterButton.layer.borderWidth = 1
        
//        self.finishButton.isEnabled = false
        
        for listOfCharacters in list{
            // create list of tuples ex.) ("vowel", [あ, い, う, え, お])
            mutableList.append((listOfCharacters.sound, listOfCharacters.letters))
            // for random character
            vowelSounds.append(JapaneseCharacters().vowelSounds)
        }
        for listOfPosibilities in posibilitiesList{
            // create list of posibilitiesList of each sound
            mutablePosibilitiesList.append(listOfPosibilities.posibilitiesList)
        }
        self.totalNumberOfCharacter = numberOfCharacters()
        // choose first chracter
        switch self.showingStyle {
        case .order:
            self.shownCharacter = orderCharacter()
        case .random:
            self.shownCharacter = randomCharacter()
        default:
            self.shownCharacter = orderCharacter()
        }
        self.updateLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func updateLabels() {
        // updates all labels
        self.commentLabel.text = self.comment.rawValue
        self.characterLabel.text = self.shownCharacter
        self.countCharacters.text = "\(self.currentNumber)/\(self.totalNumberOfCharacter)"
        switch self.judge {
        case .correct:
            self.soundLabel.text = self.sound
            self.characterLabel.backgroundColor = .green
        case .wrong:
            self.soundLabel.text = self.sound
            self.characterLabel.backgroundColor = .red
        case .wait:
            self.characterLabel.backgroundColor = .yellow
        case .yet:
            self.soundLabel.text = ""
            self.characterLabel.backgroundColor = .white
        }
//        self.nextCharacterButton.setTitle(self.buttonTitle.rawValue, for: .normal)
        if self.currentNumber == 1 {
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = false
        }
        else if self.currentNumber == self.totalNumberOfCharacter {
            self.nextButton.isEnabled = false
            self.backButton.isEnabled = true
        }
        else {
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        self.nextCharacter()
    }
     */
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        refreshTask()
        
        if self.currentNumber < self.totalNumberOfCharacter {
            if self.counter == self.currentNumber {
                self.soundLabel.text = ""
                switch self.showingStyle {
                case .order:
                    self.shownCharacter = orderCharacter()
                case .random:
                    self.shownCharacter = randomCharacter()
                default:
                    self.shownCharacter = orderCharacter()
                }
            } else {
                let nextNumber = self.currentNumber + 1
                self.sound = self.shownCharacters[nextNumber - 1].0
                self.shownCharacter = self.shownCharacters[nextNumber - 1].1
                self.posibilities = self.shownCharacters[nextNumber - 1].2
                self.currentNumber = nextNumber
            }
            self.judge = self.judgedShownCharacters[self.shownCharacter]!.0
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
            self.judge = self.judgedShownCharacters[self.shownCharacter]!.0
            self.updateLabels()
        }
    }
    
    @IBAction func buttonDown(_ sender: UIButton) {
        switch buttonTitle {
        case .next:
            return
        case .start:
            if !audioEngine.isRunning {
                if recognitionIsEnd {
                    try! startRecording()
                    recognitionIsEnd = false
                }
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
                self.audioEngine.stop()
                if self.comment != .again {
                    self.comment = .start
                }
                self.updateLabels()
            }
        }
        self.buttonTitle = .start
//        self.updateLabels()
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        let recapVC  = storyboard?.instantiateViewController(withIdentifier: "RecapViewController") as! RecapViewController
        // sends dictionaly of generated character by voice recognition to RecapViewController
        var judgedCharacters = [Judge.correct: [(String, String)](), Judge.wrong: [(String, String)]()]
        for (key, value) in judgedShownCharacters {
            switch value.0 {
            case .correct:
                judgedCharacters[.correct]?.append((value.1, key))
            default:
                judgedCharacters[.wrong]?.append((value.1, key))
            }
        }
        recapVC.judgedCharacters = judgedCharacters
        recapVC.buffer = self.buffers
        recapVC.japaneseType = self.japaneseType
        recapVC.showingStyle = self.showingStyle
        // goes to RecapViewController
        self.navigationController?.pushViewController(recapVC, animated: true)
    }
    
    func numberOfCharacters() -> Int {
        // return total number of characters that are in the list
        var numberOfCharacters = 0
        for i in 0...list.count - 1 {
            for j in 0...list[i].letters.count - 1 {
                if list[i].letters[j] != "　" {
                    numberOfCharacters += 1
                }
            }
        }
        return numberOfCharacters
    }
    
    func randomCharacter() -> String {
        // chooses a character randomly, returns it
        // generates random numbers
        let soundIndex = Int(arc4random()) % self.mutableList.count
        let vowelIndex = Int(arc4random()) % self.mutableList[soundIndex].1.count
        // picks a character with random numbers
        var showCharacter = self.mutableList[soundIndex].1[vowelIndex]
        // picks a list of possible characters of the picked character
        self.posibilities = self.mutablePosibilitiesList[soundIndex][vowelIndex]
        
        self.soundType = self.mutableList[soundIndex].0
        let vowel = self.vowelSounds[soundIndex][vowelIndex]
        // removes picked characters and list to avoid choosing again
        self.mutableList[soundIndex].1.remove(at: vowelIndex)
        self.mutablePosibilitiesList[soundIndex].remove(at: vowelIndex)
        self.vowelSounds[soundIndex].remove(at: vowelIndex)
        if showCharacter == "　" {
            if self.mutableList[soundIndex].1 == [] {
                // removes emply list
                self.mutableList.remove(at: soundIndex)
                self.mutablePosibilitiesList.remove(at: soundIndex)
                self.vowelSounds.remove(at: soundIndex)
            }
            //chooses character again
            showCharacter = randomCharacter()
        }
        else {
            if self.mutableList[soundIndex].1 == [] {
                // removes emply list
                self.mutableList.remove(at: soundIndex)
                self.mutablePosibilitiesList.remove(at: soundIndex)
                self.vowelSounds.remove(at: soundIndex)
            }
            // updates counter
            self.counter += 1
            //make correctsound
            var correctsound = ""
            if self.soundType == "vowel" {
                correctsound = vowel
            } else {
                correctsound = soundType.lowercased() + vowel
            }
            self.sound = correctsound
            self.shownCharacters.append((correctsound, showCharacter, self.posibilities))
            self.judgedShownCharacters[showCharacter] = (.yet, self.soundType)
            //updates currentNumber
            self.currentNumber = self.counter
        }
        return showCharacter
    }
    
    func orderCharacter() -> String {
        // shows a character orderly
        if self.vowelIndexCounter == list[self.soundIndexCounter].letters.count {
            self.vowelIndexCounter = 0
            self.soundIndexCounter += 1
            if self.soundIndexCounter == list.count {
                self.vowelIndexCounter = 0
                self.soundIndexCounter = 0
            }
        }
        var showCharacter = list[self.soundIndexCounter].letters[self.vowelIndexCounter]
        self.soundType = list[self.soundIndexCounter].sound
        let vowel = self.vowelSounds[self.soundIndexCounter][self.vowelIndexCounter]
        self.posibilities = self.posibilitiesList[self.soundIndexCounter].posibilitiesList[self.vowelIndexCounter]
        self.vowelIndexCounter += 1
        if showCharacter == "　" {
            showCharacter = orderCharacter()
        }
        else {
            self.counter += 1
            //makes correctsound
            var correctsound = ""
            if self.soundType == "vowel" {
                correctsound = vowel
            } else {
                correctsound = soundType.lowercased() + vowel
            }
            self.sound = correctsound
            self.judgedShownCharacters[showCharacter] = (.yet, self.soundType)
            self.shownCharacters.append((correctsound, showCharacter, self.posibilities))
            //updates currentNumber
            self.currentNumber = self.counter
        }
        return showCharacter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancel" {
            let japaneseCharactersTVC = segue.destination as! JapaneseCharactersTableViewController
            // makes lists emply lists
            japaneseCharactersTVC.selectedJapaneseList = [Japanese]()
            japaneseCharactersTVC.selectedPosibilitiesList = [Posibilities]()
            japaneseCharactersTVC.tableView.reloadData()
        }
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
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let `self` = self else { return }
            
            var isFinal = false
            
            if let result = result {
                //                let posibilities = result.transcriptions
                //                print(posibilities)//show correctsound
                self.commentLabel.text = Comment.recognizing.rawValue
                theBestString = result.bestTranscription.formattedString
//                print(self.shownCharacter + ": " + theBestString)
                if willAppend {
                    // passes first result
                    for posibility in self.posibilities {
                        if theBestString == posibility {
                            print("the appended chara..." + self.shownCharacter + ": " + theBestString)
                            self.judge = .correct
                            
                            let sound = self.judgedShownCharacters[self.shownCharacter]?.1
                            self.judgedShownCharacters[self.shownCharacter] = (self.judge, sound!)
                            
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
                            
                            let sound = self.judgedShownCharacters[self.shownCharacter]?.1
                            self.judgedShownCharacters[self.shownCharacter] = (self.judge, sound!)
                            
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
                
                self.comment = .start
                self.buttonTitle = .start
                self.updateLabels()
                
//                if error != nil {
//                    self.comment = .start
//                    self.buttonTitle = .start
//                }
//                else if self.counter == self.totalNumberOfCharacter{
//                    self.comment = .recap
//                    self.buttonTitle = .recap
//                    self.updateLabels()
//                }
//                else {
//                    self.comment = .next
//                    self.buttonTitle = .next
//                    self.updateLabels()
//                }
                
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
