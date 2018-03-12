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
}

struct SoundEffects {
    
    var player: AVAudioPlayer?
    
    let AudioSession = AVAudioSession.sharedInstance()
    
    let fileType = "mp3"
    
    mutating func swooshEffect(_ type: Swoosh) {
        switch type {
        case .one:
            soundResource(.one)
            
        case .two:
            soundResource(.two)
            
        case .three:
            soundResource(.three)
            
        case .backOne:
            soundResource(.backOne)
            
        case .backTwo:
            soundResource(.backTwo)
        
        case .backThree:
            soundResource(.backThree)
        }
    }
  
    mutating func soundResource(_ type: Swoosh) {
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: fileType) else {return}
        
        do {
            try AudioSession.setCategory(AVAudioSessionCategoryPlayback)
            try AudioSession.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else {
                return
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func swooshOne() {
//        guard let url = Bundle.main.url(forResource: "swooshOne", withExtension: "mp3") else {return}
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let swooshPlayerOne = player else {return}
//
//            swooshPlayerOne.play()
//        } catch let error{
//            print(error.localizedDescription)
//        }
//    }
//
//    func swooshTwo() {
//        guard let url = Bundle.main.url(forResource: "swooshTwo", withExtension: "mp3") else {return}
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let swooshPlayerOne = player else {return}
//
//            swooshPlayerOne.play()
//        } catch let error{
//            print(error.localizedDescription)
//        }
//    }
//
//    func swooshThree() {
//        guard let url = Bundle.main.url(forResource: "swooshThree", withExtension: "mp3") else {return}
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            guard let swooshPlayerOne = player else {return}
//
//            swooshPlayerOne.play()
//        } catch let error{
//            print(error.localizedDescription)
//        }
//    }
    
    
    
}
