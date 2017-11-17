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

enum Comment: String {
    case start = "tap start button to begin recording"
    case recording = "recording your pronunciation, say just once"
    case recognizing = "recognizing your voice, keep silent"
    case next = "tap next"
    case recap = "tap recap"
}

enum ButtonTitle: String {
    case start = "Start Voice Recognition"
    case next = "Next Character"
    case recap = "See Recap"
}

class ShowCharactersViewController: UIViewController {
    
    //values to show characters
    var list = [Japanese]()
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
    var comment = Comment.start
    var buttonTitle = ButtonTitle.start
    
    // values for voice recognization
//    let audioEngine = AVAudioEngine()
//    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
//    let request = SFSpeechAudioBufferRecognitionRequest()
//    var recognitionTask: SFSpeechRecognitionTask?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var countCharacters: UILabel!
    @IBOutlet weak var nextCharacterButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer.delegate = self
        
        self.characterLabel.layer.cornerRadius = 6
        self.characterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.characterLabel.layer.borderWidth = 1
        
//        self.soundLabel.layer.cornerRadius = 35
//        self.soundLabel.layer.borderColor = UIColor.lightGray.cgColor
//        self.soundLabel.layer.borderWidth = 1
        
        for listOfCharacters in list{
            mutableList.append(listOfCharacters.letters)
        }
        self.maxChara = numberOfCharacters()
        self.updateLabels()
    }
    
    func updateLabels() {
        if self.list[self.soundIndexCounter].sound == "vowel" {
            self.soundLabel.font = self.soundLabel.font.withSize(20.0)
         }
        else {
            self.soundLabel.font = self.soundLabel.font.withSize(40.0)
        }
        self.commentLabel.text = self.comment.rawValue
        self.soundLabel.text = self.list[self.soundIndexCounter].sound
        self.characterLabel.text = self.shownCharacter
        self.countCharacters.text = "\(self.counter)/\(self.maxChara)"
        self.nextCharacterButton.setTitle(self.buttonTitle.rawValue, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCharacterButtonTapped(_ sender: UIButton) {
        self.nextCharacter()
//        self.nextCharacterButton.isHidden = true
    }
    
    func nextCharacter() {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            nextCharacterButton.isEnabled = false
            nextCharacterButton.setTitle("停止中", for: .disabled)
        } else {
            try! startRecording()
            nextCharacterButton.setTitle("音声認識を中止", for: [])
        }
        
//        if self.counter == 0{
//            self.recordAndRecognizeSpeech(type: selectedType!)
//            self.shownCharacter = orderCharacter()
//            self.comment = .recording
//        }
//        else
        if counter < maxChara {
            self.shownCharacter = orderCharacter()
            self.comment = .recording
//            audioEngine.prepare()
//            do {
//                try audioEngine.start()
//            } catch {
//                return print(error)
//            }
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
                nextCharacterButton.isEnabled = false
                nextCharacterButton.setTitle("停止中", for: .disabled)
            } else {
                try! startRecording()
                nextCharacterButton.setTitle("音声認識を中止", for: [])
            }
        }
        else {
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
            }
            self.characterLabel.text = ""
            let recapVC  = storyboard?.instantiateViewController(withIdentifier: "RecapViewController") as! RecapViewController
            recapVC.choosedCharacters = self.list
            recapVC.generatedCharacters = self.bestString
            
            self.navigationController?.pushViewController(recapVC, animated: true)
        }
        self.decision = .yet
        self.updateLabels()
//        self.checkLabel.text = self.decision.rawValue
    }
    
    func numberOfCharacters() -> Int {
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
        if self.vowelIndexCounter == list[self.soundIndexCounter].letters.count {
            self.vowelIndexCounter = 0
            self.soundIndexCounter += 1
            if self.soundIndexCounter == list.count {
                self.vowelIndexCounter = 0
                self.soundIndexCounter = 0
            }
        }
        var showCharacter = list[self.soundIndexCounter].letters[self.vowelIndexCounter]
        if showCharacter == "　" {
            showCharacter = orderCharacter()
        }
        else {
            self.counter += 1
        }
        self.vowelIndexCounter += 1
        return showCharacter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancel" {
            let japaneseCharactersTVC = segue.destination as! JapaneseCharactersTableViewController
            japaneseCharactersTVC.selectedJapaneseList = [Japanese]()
            japaneseCharactersTVC.tableView.reloadData()
        }
    }
    
}

extension ShowCharactersViewController: SFSpeechRecognizerDelegate {
    // 音声認識の可否が変更したときに呼ばれるdelegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            nextCharacterButton.isEnabled = true
            nextCharacterButton.setTitle("音声認識スタート", for: [])
        } else {
            nextCharacterButton.isEnabled = false
            nextCharacterButton.setTitle("音声認識ストップ", for: .disabled)
        }
    }
    
    private func startRecording() throws {
        refreshTask()
        
        let audioSession = AVAudioSession.sharedInstance()
        // 録音用のカテゴリをセット
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // 録音が完了する前のリクエストを作るかどうかのフラグ。
        // trueだと現在-1回目のリクエスト結果が返ってくる模様。falseだとボタンをオフにしたときに音声認識の結果が返ってくる設定。
        recognitionRequest.shouldReportPartialResults = false
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let `self` = self else { return }
            
            var isFinal = false
            
            if let result = result {
                self.commentLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            // エラーがある、もしくは最後の認識結果だった場合の処理
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.nextCharacterButton.isEnabled = true
                self.nextCharacterButton.setTitle("音声認識スタート", for: [])
            }
        }
        // マイクから取得した音声バッファをリクエストに渡す
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
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
        // startの前にリソースを確保しておく。
        audioEngine.prepare()
        
        try audioEngine.start()
        
        commentLabel.text = "どうぞ喋ってください。"
    }
}

//voice recoginization function
//extension ShowCharactersViewController: SFSpeechRecognizerDelegate {
//    func recordAndRecognizeSpeech(type: JapaneseType) {
//        let node = audioEngine.inputNode
//        let recordingFormat = node.outputFormat(forBus: 0)
//        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
//            self.request.append(buffer)
//        }
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            return print(error)
//        }
//        guard let myRecognizer = SFSpeechRecognizer() else {
//            return
//        }
//        if !myRecognizer.isAvailable {
//            return
//        }
//
//        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
//            if let result = result {
//                let posibilities = result.transcriptions
//
//                print(posibilities)
//                if self.audioEngine.isRunning {
//                    self.audioEngine.stop()
//                }
//                self.comment = .recognizing
//                switch type {
//                case .hiragana:
//                    self.bestString = result.bestTranscription.formattedString
//                case .katakana:
//                    self.bestString = result.bestTranscription.formattedString
//                    let changeCharacter = NSMutableString(string: self.bestString) as CFMutableString
//                    CFStringTransform(changeCharacter, nil, kCFStringTransformHiraganaKatakana, false)
//                    self.bestString = changeCharacter as String
//                }
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//                    // Put your code which should be executed with a delay here
//                    if self.counter == self.maxChara{
//                        self.comment = .recap
//                        self.buttonTitle = .recap
//                    }
//                    else{
//                        self.comment = .next
//                        self.buttonTitle = .next
//                    }
//                    self.updateLabels()
//                    self.nextCharacterButton.isHidden = false
//                })
//                self.updateLabels()
//                print(self.bestString)
////                self.checkCharacter(decision: self.decision, character: lastCharacter)
//            } else {
//                print(error ?? "")
//            }
//        })
//    }
//
//    func checkCharacter(decision: Decision, character: String) {
//        switch character {
//        case self.shownCharacter:
////            switch decision {
////            case .correct:
////                self.decision = .yet
////            case .wrong:
////                self.decision = .yet
////            case .yet:
//                self.decision = .correct
////            }
//
//        default:
//            self.decision = .wrong
//        }
//        print(self.decision)
////        self.checkLabel.text = self.decision.rawValue
//        if audioEngine.isRunning {
//            audioEngine.stop()
//        }
//    }
//
//    private func refreshTask() {
//        if let recognitionTask = recognitionTask {
//            recognitionTask.cancel()
//            self.recognitionTask = nil
//        }
//    }
//}

