//
//  AppDelegate.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/10/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audio = AVAudioPlayer()
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after app launch,
        //  but before state restoration.
//        do {
//            audio = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Metal_Gong", ofType: "mp3")!))
//            audio.prepareToPlay()
//            audio.enableRate = true
//            audio.rate = 1.8
//        } catch {
//            print(error)
//        }
        // Do any additional setup after loading the view.
        
//        audio.play()
        
//        let initialViewController: UIViewController
//        let tempStoryboard = UIStoryboard(name: "CharactersSelection", bundle: .main)
//        initialViewController = tempStoryboard.instantiateInitialViewController()!
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
        let isopened = UserDefaults.standard.bool(forKey: "OpenApp")
        let isFirstTime = UserDefaults.standard.bool(forKey: "FirstTimeUser")
        if !isopened && !isFirstTime {
            UserDefaults.standard.set(true, forKey: "OpenApp")
        }
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        UIApplication.shared.statusBarStyle = .lightContent
//        Thread.sleep(forTimeInterval: 3.0)
        let isopened = UserDefaults.standard.bool(forKey: "OpenApp")
        let isFirstTime = UserDefaults.standard.bool(forKey: "FirstTimeUser")
        if isopened && !isFirstTime {
            coredataSetup()
            UserDefaults.standard.set(true, forKey: "FirstTimeUser")
        }
        return true
    }
    
    func coredataSetup() {
        let coreDataStack = CoreDataStack.instance
        let saveContext = coreDataStack.privateContext
        
        let japaneseCharacters = JapaneseCharacters.instance
        
        for japanese in japaneseCharacters.hiraganaList {
            let consonant = Consonant(context: saveContext)
            consonant.unLockNext = japanese.unLockNext
            consonant.consonant = japanese.sound
            consonant.system = JapaneseType.hiragana.rawValue
            for character in japanese.letters {
                let wordLearnt = WordLearnt(context: saveContext)
                wordLearnt.word = character
                wordLearnt.confidenceCounter = 0
                wordLearnt.consonant = consonant
            }
        }
        
        for japanese in japaneseCharacters.katakanaList {
            let consonant = Consonant(context: saveContext)
            consonant.unLockNext = japanese.unLockNext
            consonant.consonant = japanese.sound
            consonant.system = JapaneseType.katakana.rawValue
            for character in japanese.letters {
                let wordLearnt = WordLearnt(context: saveContext)
                wordLearnt.word = character
                wordLearnt.confidenceCounter = 0
                wordLearnt.consonant = consonant
            }
        }
        
        for japanese in japaneseCharacters.yVowelHiraganaList {
            let consonant = Consonant(context: saveContext)
            consonant.unLockNext = japanese.unLockNext
            consonant.consonant = japanese.sound
            consonant.system = JapaneseType.yVowelHiragana.rawValue
            for character in japanese.letters {
                let wordLearnt = WordLearnt(context: saveContext)
                wordLearnt.word = character
                wordLearnt.confidenceCounter = 0
                wordLearnt.consonant = consonant
            }
        }
        
        for japanese in japaneseCharacters.yVowelKatakanaList {
            let consonant = Consonant(context: saveContext)
            consonant.unLockNext = japanese.unLockNext
            consonant.consonant = japanese.sound
            consonant.system = JapaneseType.yVowelKatakana.rawValue
            for character in japanese.letters {
                let wordLearnt = WordLearnt(context: saveContext)
                wordLearnt.word = character
                wordLearnt.confidenceCounter = 0
                wordLearnt.consonant = consonant
            }
        }
        
        coreDataStack.saveTo(context: saveContext)
    }
}

