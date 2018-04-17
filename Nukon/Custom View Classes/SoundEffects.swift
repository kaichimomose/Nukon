//
//  SoundEffects.swift
//  Nukon
//
//  Created by Chris Mauldin on 3/12/18.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import Foundation
import AVFoundation


enum Swoosh: String {
    case one = "swooshOne"
    case two = "swooshTwo"
    case three = "swooshThree"
    
    case backOne = "swooshBackOne"
    case backTwo = "swooshBackTwo"
    case backThree = "swooshBackThree"
    
    case water = "water"
    case fire = "fire"
    case inflate = "inflate"
}

enum TransitionSound: String {
    case stretch = "cartoon"
}

enum Guesses: String {
    case right = "bell_2x"
    case wrong = "boing"
}

struct SoundEffects {
    
    var player: AVAudioPlayer?
    
    let AudioSession = AVAudioSession.sharedInstance()
    
    let fileType = "mp3"
    
    mutating func sound(_ swooshType: Swoosh?, _ guessType: Guesses?, _ transitionSoundType: TransitionSound?) {
        if let swoosh = swooshType {
            switch swoosh {
            case .one:
                swooshResource(.one)
                
            case .two:
                swooshResource(.two)
                
            case .three:
                swooshResource(.three)
                
            case .backOne:
                swooshResource(.backOne)
                
            case .backTwo:
                swooshResource(.backTwo)
            
            case .backThree:
                swooshResource(.backThree)
                
            case .water:
                swooshResource(.water)
                
            case .fire:
                swooshResource(.fire)
                
            case .inflate:
                swooshResource(.inflate)
            }
        }
        
        if let guess = guessType {
            switch guess {
            case .right:
                guessEffectResource(.right)
                
            case .wrong:
                guessEffectResource(.wrong)
            }
        }
        
        if let transSound = transitionSoundType {
            switch transSound {
            case .stretch:
                transitionEffectResource(.stretch)
            }
        }
    }
  
    mutating func swooshResource(_ type: Swoosh) {
        guard let swooshUrl = Bundle.main.url(forResource: type.rawValue, withExtension: fileType) else {return}
        
        do {
            try AudioSession.setCategory(AVAudioSessionCategoryPlayback)
            try AudioSession.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: swooshUrl, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else {
                return
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    mutating func guessEffectResource(_ type: Guesses) {
        guard let guessUrl = Bundle.main.url(forResource: type.rawValue, withExtension: fileType) else {return}
        
        do {
            try AudioSession.setCategory(AVAudioSessionCategoryPlayback)
            try AudioSession.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: guessUrl, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else {
                return
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    mutating func transitionEffectResource(_ type: TransitionSound) {
        
        guard let transitionSoundUrl = Bundle.main.url(forResource: type.rawValue, withExtension: fileType) else {return}
        
        do {
            try AudioSession.setCategory(AVAudioSessionCategoryPlayback)
            try AudioSession.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: transitionSoundUrl, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else {
                return
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
