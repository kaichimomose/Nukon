//
//  AnalysisViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/25.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation

class AnalysisViewController: UIViewController {

    @IBOutlet weak var shownCharacterLabel: UILabel!
    @IBOutlet weak var generatedCharacterLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var audioEngine: AVAudioEngine!
    var audioInputNode : AVAudioInputNode!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioMixerNode: AVAudioMixerNode!
    var audioBuffer: AVAudioPCMBuffer!
    
    var generatedCharacter: (String, String)!
    var buffer: AVAudioPCMBuffer!
    var tapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shownCharacterLabel.text = generatedCharacter?.0 ?? ""
        generatedCharacterLabel.text = generatedCharacter?.1 ?? ""
        
        self.shownCharacterLabel.layer.cornerRadius = 6
        self.shownCharacterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.shownCharacterLabel.layer.borderWidth = 1

        self.generatedCharacterLabel.layer.cornerRadius = 6
        self.generatedCharacterLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.generatedCharacterLabel.layer.borderWidth = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // setup audio engine
        if tapped == false {
            audioEngine = AVAudioEngine()
            audioPlayerNode = AVAudioPlayerNode()
            audioInputNode = audioEngine?.inputNode
            audioMixerNode = audioEngine?.mainMixerNode
            audioBuffer = buffer
            
            audioEngine?.attach(audioPlayerNode!)
            audioEngine?.connect(audioPlayerNode!, to: audioMixerNode!, format: audioBuffer.format)
    //        audioEngine.startAndReturnError(nil)
        
            try! startAudioEngine()
            audioPlayerNode?.play()
            audioPlayerNode?.scheduleBuffer(audioBuffer!, at: nil, options: .loops, completionHandler: nil)
            tapped = true
        }
        else {
            audioEngine?.stop()
            tapped = false
        }
    }
    
    func startAudioEngine() throws {
        // prepare resource before starting
        audioEngine?.prepare()
        
        try audioEngine?.start()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
