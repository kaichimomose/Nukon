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
    var list: [[String]]?
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
        maxChara = numberOfCharacters()
        if let list = list {
            mutableList = list
        }
        self.shownCharacter = orderCharacter()
        characterLabel.text = self.shownCharacter
        countCharacters.text = "\(counter)/\(maxChara)"
        self.spokenCharacterLabel.text = "recording"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        self.nextCharacter()
//        refreshTask()
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            return print(error)
//        }
    }
    
    func nextCharacter() {
        if counter < maxChara {
            self.spokenCharacterLabel.text = "recording"
            self.shownCharacter = orderCharacter()
            characterLabel.text = self.shownCharacter
            countCharacters.text = "\(counter)/\(maxChara)"
        }
        else {
            characterLabel.text = ""
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
                for j in 0...list[i].count - 1 {
                    if list[i][j] != "　" {
                        numberOfCharacters += 1
                    }
                }
            }
            return numberOfCharacters
        } else {return 0}
    }
    
    func randomCharacter() -> String {
        let soundIndex = Int(arc4random()) % mutableList.count
        let vowelIndex = Int(arc4random()) % mutableList[soundIndex].count
        var showCharacter = mutableList[soundIndex][vowelIndex]
        mutableList[soundIndex].remove(at: vowelIndex)
        if showCharacter == "　" {
            showCharacter = randomCharacter()
        }
        else {
            if mutableList[soundIndex] == [] {
                mutableList.remove(at: soundIndex)
            }
            counter += 1
        }
        return showCharacter
    }
    
    func orderCharacter() -> String {
        if let list = list {
            if vowelIndexCounter == list[soundIndexCounter].count {
                vowelIndexCounter = 0
                soundIndexCounter += 1
                if soundIndexCounter == list.count {
                    vowelIndexCounter = 0
                    soundIndexCounter = 0
                }
            }
            vowelIndexCounter += 1
            var showCharacter = list[soundIndexCounter][vowelIndexCounter - 1]
            if showCharacter == "　" {
                showCharacter = orderCharacter()
            }
            else {
                counter += 1
            }
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
                self.bestString = result.bestTranscription.formattedString
                let posibilities = result.transcriptions
                
                print(posibilities)
                
//                let lastCharacter = String(describing: self.bestString.last!)
                
                switch type {
                case .hiragana:
                    if self.counter == self.maxChara{
                        self.spokenCharacterLabel.text = "tap recap"
                        self.nextCharacterButton.setTitle("Recap", for: .normal)
                    }
                    else{
                        self.spokenCharacterLabel.text = "tap next"
                    }
                case .katakana:
                    let changeCharacter = NSMutableString(string: self.bestString) as CFMutableString
                    CFStringTransform(changeCharacter, nil, kCFStringTransformHiraganaKatakana, false)
                    self.bestString = changeCharacter as String
                    if self.counter == self.maxChara{
                        self.spokenCharacterLabel.text = "tap recap"
                        self.nextCharacterButton.setTitle("Recap", for: .normal)
                    }
                    else{
                        self.spokenCharacterLabel.text = "tap next"
                    }
                }
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

