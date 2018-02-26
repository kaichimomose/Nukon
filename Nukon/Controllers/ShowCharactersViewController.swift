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

enum Judge: String {
    case correct = "✔️"
    case wrong = "✖️"
    case wait = "w"
    case yet = ""
}

enum Comment: String {
    case start = "Hold button to record"
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

class ShowCharactersViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //values to show characters
    var japaneseList: [Japanese]!
    var japaneseDict: [String: [String?]]!
    let instance = PosibilitiesDict.instance
    var posibilitiesDict = [String: [String]]()
    var japaneseType: JapaneseType!
    var soundAndLettersList = [(String, [String?])]()
    let vowels = JapaneseCharacters().vowelSounds
    
    var notOkJapaneseList = [String]()
    var goodJapaneseList = [String]()
    
    //coredata management
    let coreDataStack = CoredataStack.instance
    
    lazy var fetchedResultController: NSFetchedResultsController<WordLearnt> = {
        // Remember to specify type: *CoreData Bug*
        // Initialize Fetch Request\
        let fetchRequest: NSFetchRequest<WordLearnt> = WordLearnt.fetchRequest()
        
        // Add any SortDescriptors
        let sortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Specific type Descriptors
        fetchRequest.predicate = NSPredicate(format: "type == %@", japaneseType.rawValue)
        
        // Initialize Fetched Results Controller
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.coreDataStack.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // Configure Fetched Results Controller
        fetchedResultController.delegate = self
        
        return fetchedResultController
        
    }()
    
    var list = [Japanese]()
    var vowelSounds = [[String]]()
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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var notOkButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
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
        
        self.finishButton.isHidden = true
        
        guard let japaneseDict = self.japaneseDict, let japaneseList = self.japaneseList, let japaneseType = self.japaneseType else {return}
        for japanese in japaneseList{
            if let letters = japaneseDict[japanese.sound] {
                // create list of tuples ex.) ("vowel", [あ, い, う, え, お])
                self.soundAndLettersList.append((japanese.sound, letters))
                // for random character
                vowelSounds.append(JapaneseCharacters().vowelSounds)
            }
        }
        
        switch japaneseType {
        case .hiragana, .katakana:
            self.posibilitiesDict = instance.regularPosibilitiesDict
        case .voicedHiragana, .voicedKatakana:
            self.posibilitiesDict = [:]
        case .yVowelHiragana, .yVowelKatakana:
            self.posibilitiesDict = [:]
        }
        
        self.totalNumberOfCharacter = numberOfCharacters()
        // choose first chracter
        self.shownCharacter = orderCharacter()
//        switch self.showingStyle {
//        case .order:
//            self.shownCharacter = orderCharacter()
//        case .random:
//            self.shownCharacter = randomCharacter()
//        default:
//            self.shownCharacter = orderCharacter()
//        }
        self.updateLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! fetchedResultController.performFetch()
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
            self.soundLabel.text = self.sound
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
    
    func numberOfCharacters() -> Int {
        // return total number of characters that are in the list
        var numberOfCharacters = 0
        
        for (_, value) in self.japaneseDict {
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
        if self.vowelIndexCounter == soundAndLettersList[self.soundIndexCounter].1.count {
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
        let vowel = self.vowels[self.vowelIndexCounter]
//        self.posibilities = self.posibilitiesDict[showCharacter]!
        self.vowelIndexCounter += 1
        self.counter += 1
        //makes correctsound
        var correctsound = ""
        if self.soundType == "vowel" {
            correctsound = vowel
        } else {
            correctsound = soundType.lowercased() + vowel
        }
        self.posibilities = self.posibilitiesDict[correctsound]!
        self.sound = correctsound
        self.judgedShownCharacters[showCharacter] = (.yet, self.soundType)
        self.shownCharacters.append((correctsound, showCharacter, self.posibilities))
        //updates currentNumber
        self.currentNumber = self.counter
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
    
    func updateCoreData() {
        //find word in correctWord from coredata [WordLearnt], if found update number of correct and give point
        let saveContext = coreDataStack.privateContext
        guard let wordLearnts = fetchedResultController.fetchedObjects else {return}
        for character in goodJapaneseList {
            var find = false //flag to decide whether find or not
            for wordLearnt in wordLearnts {
                if wordLearnt.word == character {
                    let backendEntity = coreDataStack.privateContext.object(with: wordLearnt.objectID) as! WordLearnt
                    if backendEntity.confidenceCounter < 5 {
                        backendEntity.confidenceCounter += 1
                    }
                    //update flag
                    find = true
                    break
                }
            }
            //if not found, insert word to coredata and give points
            if !find {
                let newWordLearnt = WordLearnt(
                    context: saveContext
                )
                newWordLearnt.word = character
                newWordLearnt.confidenceCounter = 1
                newWordLearnt.type = japaneseType.rawValue
            }
        }
        //find word in correctWord from coredata [WordLearnt], if found update number of wrong
        for character in notOkJapaneseList {
            var find = false //flag to decide whether find or not
            for wordLearnt in wordLearnts {
                if wordLearnt.word == character {
                    let backendEntity = coreDataStack.privateContext.object(with: wordLearnt.objectID) as! WordLearnt
                    if backendEntity.confidenceCounter > 0 {
                        backendEntity.confidenceCounter -= 1
                    }
                    find = true
                    break
                }
            }
            //if not found, insert word to coredata
            if find == false{
                let newWordLearnt = WordLearnt(
                    context: saveContext
                )
                newWordLearnt.word = character
                newWordLearnt.confidenceCounter = 0
                newWordLearnt.type = japaneseType.rawValue
            }
        }
        // saves core data
        coreDataStack.saveTo(context: coreDataStack.privateContext)
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
        self.soundLabel.alpha = 0
        self.soundLabel.text = ""
        
        let fadein = {
            self.soundLabel.text = self.sound
            self.soundLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: [.repeat,.autoreverse], animations: fadein, completion: nil)
    }
    
    @IBAction func characterTapped(_ sender: Any) {
        speakJapanese(string: self.shownCharacter)
        soundAnimation()
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        refreshTask()
        
        if self.currentNumber < self.totalNumberOfCharacter {
            if self.counter == self.currentNumber {
                self.soundLabel.text = ""
                self.shownCharacter = orderCharacter()
//                switch self.showingStyle {
//                case .order:
//                    self.shownCharacter = orderCharacter()
//                case .random:
//                    self.shownCharacter = randomCharacter()
//                default:
//                    self.shownCharacter = orderCharacter()
//                }
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notOkButtonTapped(_ sender: Any) {
        self.notOkJapaneseList.append(self.shownCharacter)
        if counter == totalNumberOfCharacter {
            notOkButton.isHidden = true
            goodButton.isHidden = true
            finishButton.isHidden = false
        } else {
            self.shownCharacter = orderCharacter()
            self.comment = .start
            self.buttonTitle = .start
            self.judge = self.judgedShownCharacters[self.shownCharacter]!.0
            self.updateLabels()
        }
        
    }
    
    @IBAction func goodButtonTapped(_ sender: Any) {
        self.goodJapaneseList.append(self.shownCharacter)
        if counter == totalNumberOfCharacter {
            notOkButton.isHidden = true
            goodButton.isHidden = true
            finishButton.isHidden = false
        } else {
            self.shownCharacter = orderCharacter()
            self.comment = .start
            self.buttonTitle = .start
            self.judge = self.judgedShownCharacters[self.shownCharacter]!.0
            self.updateLabels()
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
                            
                            willAppend = false
                            recognitionRequest.shouldReportPartialResults = false
                            recognitionRequest.endAudio()
                            self.recognitionIsEnd = true
                            break
                        }
                    }
                    
                    if willAppend {
                        if theBestString.count > 2 && !self.isAlpha(char: theBestString.first!) {
                            self.judge = .wait
                            
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
