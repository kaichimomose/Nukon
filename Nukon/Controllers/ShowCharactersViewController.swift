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
    case yet = ""
}

enum Comment: String {
    case start = "tap start button if you are ready"
    case recording = "recording your pronunciation, say just once"
    case recap = "tap recap"
}

enum ButtonTitle: String {
    case start = "Start Voice Recognition"
    case stop = "Stop Voice Recognition"
    case next = "Next Character"
    case recap = "See Recap"
}

class ShowCharactersViewController: UIViewController {
    
    //values to show characters
    var list = [Japanese]()
    var vowelSounds = [[String]]()
    var japaneseType: JapaneseType!
    var shownCharacter = ""
    var soundType = ""
    var vowel = ""
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var counter: Int = 0
    var totalNumberOfCharacter: Int = 0
    var mutableList = [(String, [String])]()
    var judge = Judge.yet
    var comment = Comment.start
    var buttonTitle = ButtonTitle.start
    var bestString = [Judge.correct: [(String, String, String)](), Judge.wrong: [(String, String, String)]()]
    var buffers = [AVAudioPCMBuffer]()
    var buffer: AVAudioPCMBuffer!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer.delegate = self
        
        self.characterLabel.layer.cornerRadius = 6
        self.characterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.characterLabel.layer.borderWidth = 1
        
        for listOfCharacters in list{
            // create list of tuples ex.) ("vowel", [あ, い, う, え, お])
            mutableList.append((listOfCharacters.sound, listOfCharacters.letters))
            vowelSounds.append(JapaneseCharacters().vowelSounds)
        }
        for listOfPosibilities in posibilitiesList{
            // create list of posibilitiesList of each sound
            mutablePosibilitiesList.append(listOfPosibilities.posibilitiesList)
        }
        self.totalNumberOfCharacter = numberOfCharacters()
        // choose first chracter
        self.shownCharacter = randomCharacter()
        self.updateLabels()
    }
    
    func updateLabels() {
        // updates all labels
        if self.soundType == "vowel" {
            self.soundLabel.font = self.soundLabel.font.withSize(20.0)
         }
        else {
            self.soundLabel.font = self.soundLabel.font.withSize(40.0)
        }
        self.commentLabel.text = self.comment.rawValue
        self.soundLabel.text = self.soundType
        self.characterLabel.text = self.shownCharacter
        self.countCharacters.text = "\(self.counter)/\(self.totalNumberOfCharacter)"
        self.judgeLabel.text = self.judge.rawValue
        switch self.judge {
        case .correct:
            self.characterLabel.layer.backgroundColor = UIColor.green.cgColor
        case .wrong:
            self.characterLabel.layer.backgroundColor = UIColor.red.cgColor
        case .yet:
            self.characterLabel.layer.backgroundColor = UIColor.clear.cgColor
        }
        self.nextCharacterButton.setTitle(self.buttonTitle.rawValue, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        self.nextCharacter()
    }
    
    func nextCharacter() {
        // changes funtion based on button title
        switch buttonTitle {
        case .next:
            self.shownCharacter = randomCharacter()
            self.buttonTitle = .start
        case .start:
            try! startRecording()
            self.buttonTitle = .stop
            self.comment = .recording
        case .stop:
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
                nextCharacterButton.isEnabled = false
                nextCharacterButton.setTitle("Stopping", for: .disabled)
            }
            self.comment = .start
            self.buttonTitle = .start
        case .recap:
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
            }
            let recapVC  = storyboard?.instantiateViewController(withIdentifier: "RecapViewController") as! RecapViewController
            // sends dictionaly of generated character by voice recognition to RecapViewController
            recapVC.generatedCharacters = self.bestString
            recapVC.buffer = self.buffers
            recapVC.japaneseType = self.japaneseType
            // goes to RecapViewController
            self.navigationController?.pushViewController(recapVC, animated: true)
        }
        self.judge = .yet
        self.updateLabels()
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
        print(self.mutableList)
        let soundIndex = Int(arc4random()) % self.mutableList.count
        let vowelIndex = Int(arc4random()) % self.mutableList[soundIndex].1.count
        // picks a character with random numbers
        var showCharacter = self.mutableList[soundIndex].1[vowelIndex]
        // picks a list of possible characters of the picked character
        self.posibilities = self.mutablePosibilitiesList[soundIndex][vowelIndex]
        
        self.soundType = self.mutableList[soundIndex].0
        self.vowel = self.vowelSounds[soundIndex][vowelIndex]
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
            // update counter
            self.counter += 1
        }
        print(self.mutableList)
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
        self.posibilities = self.posibilitiesList[self.soundIndexCounter].posibilitiesList[self.vowelIndexCounter]
        self.vowelIndexCounter += 1
        if showCharacter == "　" {
            showCharacter = orderCharacter()
        }
        else {
            self.counter += 1
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
    
}

extension ShowCharactersViewController: SFSpeechRecognizerDelegate {
    // delegate called when availability of voice recognition is changed
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            nextCharacterButton.isEnabled = true
            self.buttonTitle = .start
            nextCharacterButton.setTitle(self.buttonTitle.rawValue, for: [])
        } else {
            nextCharacterButton.isEnabled = false
            nextCharacterButton.setTitle("voice recognition is unavailable", for: .disabled)
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
        
        var willAppend = false

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let `self` = self else { return }
            
            var isFinal = false
            
            if let result = result {
//                let posibilities = result.transcriptions
//                print(posibilities)
                
                //show correctsound
                var correctsound = ""
                if self.soundType == "vowel" {
                    correctsound = self.vowel
                } else {
                    correctsound = self.soundType.lowercased() + self.vowel
                }
                self.commentLabel.text = correctsound
                
                let theBestString = result.bestTranscription.formattedString
                if willAppend == true {
                    // passes first result
                    for posibility in self.posibilities {
                        if theBestString == posibility {
                            self.judge = .correct
                            //self.bestString[self.judge]!.append((self.shownCharacter, self.shownCharacter, correctsound)) //returns correctsound
                            self.bestString[self.judge]!.append((self.shownCharacter, self.shownCharacter, self.soundType)) //returns soundType
//                            self.judgeLabel.text = self.judge.rawValue
                            self.characterLabel.layer.backgroundColor = UIColor.green.cgColor
                            willAppend = false
                            break
                        }
                    }
                    
                }
                if willAppend == true {
                    // passes when a character has been already appended
                    self.judge = .wrong
                    //self.bestString[self.judge]!.append((self.shownCharacter, theBestString, correctsound)) //returns correctsound
                    self.bestString[self.judge]!.append((self.shownCharacter, theBestString, self.soundType)) //returns soundType
                    self.buffers.append(self.buffer)
//                    self.judgeLabel.text = self.judge.rawValue
                    self.characterLabel.layer.backgroundColor = UIColor.red.cgColor
                    willAppend = false
                }
                
                isFinal = result.isFinal
                // change true to false to get final result quickly
                recognitionRequest.shouldReportPartialResults = false
                willAppend = true
                // stop recording
                self.audioEngine.stop()
                recognitionRequest.endAudio()
                self.nextCharacterButton.isEnabled = false
                self.nextCharacterButton.setTitle("Stopping", for: .disabled)
            }
            
            
            // error handle and the handle after getting final result
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.nextCharacterButton.isEnabled = true
                if error != nil {
                    self.comment = .start
                    self.buttonTitle = .start
                }
                else if self.counter == self.totalNumberOfCharacter{
                    self.comment = .recap
                    self.buttonTitle = .recap
                }
                else{
                    self.comment = .start
                    self.buttonTitle = .next
                }
                self.nextCharacterButton.setTitle(self.buttonTitle.rawValue, for: [])
            }
        }
        // give an buffer from microphone to the request
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.buffer = buffer
            self.recognitionRequest?.append(buffer)
        }
        
        
        try startAudioEngine()
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

