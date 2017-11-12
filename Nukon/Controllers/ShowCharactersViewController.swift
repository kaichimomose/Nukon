//
//  ShowCharactersViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/30.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import Speech

enum Decision: String {
    case correct = "⭕️"
    case wrong = "❌"
    case yet = ""
}

class ShowCharactersViewController: UIViewController {
    
    //values to show characters
    var list: [Japanese]?
    var appearedCharacters = [String]()
    var shownCharacter = ""
    var vowelIndexCounter: Int = 0
    var soundIndexCounter: Int = 0
    var counter: Int = 0
    var maxChara: Int = 0
    var mutableList = [[String]]()
    var selectedType: JapaneseType?
    var decision = Decision.yet
    var bestString = ""
    
    // values for voice recognization
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    @IBOutlet weak var spokenCharacterLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characterLabel.layer.cornerRadius = 6
        self.characterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.characterLabel.layer.borderWidth = 1
        
        if let list = list {
            for listOfCharacters in list{
                mutableList.append(listOfCharacters.letters)
            }
        }
        self.maxChara = numberOfCharacters()
        self.shownCharacter = orderCharacter()
        self.characterLabel.text = self.shownCharacter
        self.countCharacters.text = "\(self.counter)/\(self.maxChara)"
        self.spokenCharacterLabel.text = "recording"
//        self.nextCharacterButton.isEnabled = false
        self.nextCharacterButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        self.nextCharacter()
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            return print(error)
//        }
//        self.nextCharacterButton.isEnabled = false
        self.nextCharacterButton.isHidden = true
    }
    
    func nextCharacter() {
        if counter < maxChara {
            self.spokenCharacterLabel.text = "recording"
            self.shownCharacter = orderCharacter()
            self.characterLabel.text = self.shownCharacter
            self.countCharacters.text = "\(self.counter)/\(self.maxChara)"
        }
        else {
            self.characterLabel.text = ""
            let recapVC  = storyboard?.instantiateViewController(withIdentifier: "RecapViewController") as! RecapViewController
            recapVC.choosedCharacters = self.list
            recapVC.generatedCharacters = self.bestString
            
            self.navigationController?.pushViewController(recapVC, animated: true)
        }
        self.decision = .yet
//        self.checkLabel.text = self.decision.rawValue
    }
    
    func numberOfCharacters() -> Int {
        if let list = list {
            var numberOfCharacters = 0
            for i in 0...list.count - 1 {
                for j in 0...list[i].letters.count - 1 {
                    if list[i].letters[j] != "　" {
                        numberOfCharacters += 1
                    }
                }
            }
            return numberOfCharacters
        } else {return 0}
    }
    
    func randomCharacter() -> String {
        let soundIndex = Int(arc4random()) % self.mutableList.count
        let vowelIndex = Int(arc4random()) % self.mutableList[soundIndex].count
        var showCharacter = self.mutableList[soundIndex][vowelIndex]
        self.mutableList[soundIndex].remove(at: vowelIndex)
        if showCharacter == "　" {
            showCharacter = randomCharacter()
        }
        else {
            if self.mutableList[soundIndex] == [] {
                self.mutableList.remove(at: soundIndex)
            }
            self.counter += 1
        }
        return showCharacter
    }
    
    func orderCharacter() -> String {
        if let list = list {
            if self.vowelIndexCounter == list[self.soundIndexCounter].letters.count {
                self.vowelIndexCounter = 0
                self.soundIndexCounter += 1
                if self.soundIndexCounter == list.count {
                    self.vowelIndexCounter = 0
                    self.soundIndexCounter = 0
                }
            }
            var showCharacter = list[self.soundIndexCounter].letters[self.vowelIndexCounter]
            self.soundLabel.text = list[self.soundIndexCounter].sound
            if showCharacter == "　" {
                showCharacter = orderCharacter()
            }
            else {
                self.counter += 1
            }
            self.vowelIndexCounter += 1
            return showCharacter
        } else {return ""}
    }
    
//    func findNewCharacter() {
//        let willAppearCharacter = randomCharacter()
//        for character in appearedCharacters {
//            if willAppearCharacter == character {
//                findNewCharacter()
//            }
//            else {
//                characterLabel.text = willAppearCharacter
//            }
//        }
//    }
    
}

//voice recoginization function
extension ShowCharactersViewController: SFSpeechRecognizerDelegate {
    func recordAndRecognizeSpeech(type: JapaneseType) {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
//                let posibilities = result.transcriptions
                
//                print(posibilities)

                switch type {
                case .hiragana:
                    self.bestString = result.bestTranscription.formattedString
                case .katakana:
                    self.bestString = result.bestTranscription.formattedString
                    let changeCharacter = NSMutableString(string: self.bestString) as CFMutableString
                    CFStringTransform(changeCharacter, nil, kCFStringTransformHiraganaKatakana, false)
                    self.bestString = changeCharacter as String
                }
//                if self.audioEngine.isRunning {
//                    self.audioEngine.stop()
//                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    // Put your code which should be executed with a delay here
                    if self.counter == self.maxChara{
                        self.spokenCharacterLabel.text = "tap recap"
                        self.nextCharacterButton.setTitle("Recap", for: .normal)
                    }
                    else{
                        self.spokenCharacterLabel.text = "tap next"
                    }
//                    self.nextCharacterButton.isEnabled = true
                    self.nextCharacterButton.isHidden = false
                })
                print(self.bestString)
//                self.checkCharacter(decision: self.decision, character: lastCharacter)
            } else {
                print(error ?? "")
            }
        })
    }
    
    func checkCharacter(decision: Decision, character: String) {
        switch character {
        case self.shownCharacter:
//            switch decision {
//            case .correct:
//                self.decision = .yet
//            case .wrong:
//                self.decision = .yet
//            case .yet:
                self.decision = .correct
//            }

        default:
            self.decision = .wrong
        }
        print(self.decision)
//        self.checkLabel.text = self.decision.rawValue
        if audioEngine.isRunning {
            audioEngine.stop()
        }
    }
    
    private func refreshTask() {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
}

