//
//  JapaneseCharactersCollectionViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/02/06.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit
import AVFoundation

class JapaneseCharactersCollectionViewController: UIViewController {

    let japanese = JapaneseCharacters().hiraganaList
    let vowels = JapaneseCharacters().vowelSounds
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var parentsStackView: UIStackView!
    @IBOutlet weak var childrenStackView: UIStackView!
    @IBOutlet weak var sixthChidStackView: UIStackView!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var ilabel: UILabel!
    @IBOutlet weak var ulabel: UILabel!
    @IBOutlet weak var elabel: UILabel!
    @IBOutlet weak var olabel: UILabel!
    @IBOutlet weak var nLabel: UILabel!
    
    var labels = [UILabel]()
    @IBOutlet var soundButtons: [UIButton]!
    @IBOutlet var soundsLabels: [UILabel]!
    
    let layout = UICollectionViewFlowLayout() //UPCarouselFlowLayout()
    let inset = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SoundsCell", bundle: .main), forCellWithReuseIdentifier: "SoundsCell")
        collectionView.register(UINib.init(nibName: "FirstCharacterCell", bundle: .main), forCellWithReuseIdentifier: "FirstCharacterCell")

        let length = UIScreen.main.bounds.width - (inset.left+inset.right)
        
        // Do any additional setup after loading the view.
        layout.scrollDirection = .horizontal
        layout.sectionInset = inset
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: length, height: length)
        layout.itemSize = CGSize(width: length, height: length)
        
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceHorizontal = true
        
        parentsStackView.isHidden = true

        labels = [aLabel, ilabel, ulabel, elabel, olabel, nLabel]
        
        labels.forEach { label in
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 0.5
            label.layer.cornerRadius = 25
            label.layer.masksToBounds = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitTapped(_ sender: Any) {
//        exitButton.isHidden = true
//        childrenStackView.isHidden = true
        collectionView.collectionViewLayout.invalidateLayout()
        parentsStackView.isHidden = true
        collectionView.isUserInteractionEnabled = true
        for stackView in childrenStackView.arrangedSubviews {
            stackView.isHidden = false
        }
    }
    
    func animateView() {

        self.childrenStackView.alpha = 0
        
        self.labels.forEach({ label in
            label.transform = CGAffineTransform(rotationAngle: 90).concatenating(CGAffineTransform(translationX: 0, y: -200))
            label.alpha = 0
        })
        
        self.soundsLabels.forEach { label in
            label.alpha = 0
        }
        
        self.soundButtons.forEach { button in
            button.alpha = 0
            button.isEnabled = false
        }
        
        
        let animations = {
//            self.childrenStackView.axis = .horizontal
            
            self.childrenStackView.transform = CGAffineTransform.identity
            self.childrenStackView.alpha = 1
            
            var delay: Double = 0.3
            
            for i in 0..<self.labels.count {
                
                let labelsAnimations = {
                    self.labels[i].transform = CGAffineTransform.identity
                    self.labels[i].alpha = 1
                    self.soundsLabels[i].alpha = 1
                    guard let character = self.labels[i].text else {return}
                    self.speakJapanese(string: character)
                }
            
                UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: labelsAnimations, completion: nil)
                
                delay += 0.5
            }
            
            let buttonAnimation = {
                self.soundButtons.forEach({ button in
                    button.alpha = 1
                    button.isEnabled = true
                })
            }
            
            UIView.animate(withDuration: 1.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: buttonAnimation, completion: nil)
            
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: animations, completion: nil)
    }
    
    func speakJapanese(string: String) {
        let textToSpeak = AVSpeechUtterance(string: string)
        textToSpeak.rate = 0.3
        textToSpeak.volume = 1.0
        //        let numberOfSeconds = 10.0
        //        textToSpeak.preUtteranceDelay = numberOfSeconds
        let speakerVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        let speak = AVSpeechSynthesizer()
        textToSpeak.voice = speakerVoice
        //        speak.delegate = self
        speak.speak(textToSpeak)
    }
    
    @IBAction func aLabelSoundTappped(_ sender: Any) {
        let character = aLabel.text
        speakJapanese(string: character!)
    }
    @IBAction func iLabelSoundTappped(_ sender: Any) {
        let character = ilabel.text
        speakJapanese(string: character!)
    }
    @IBAction func uLabelSoundTappped(_ sender: Any) {
        let character = ulabel.text
        speakJapanese(string: character!)
    }
    @IBAction func eLabelSoundTappped(_ sender: Any) {
        let character = elabel.text
        speakJapanese(string: character!)
    }
    @IBAction func oLabelSoundTappped(_ sender: Any) {
        let character = olabel.text
        speakJapanese(string: character!)
    }
    @IBAction func nLabelSoundTappped(_ sender: Any) {
        let character = nLabel.text
        speakJapanese(string: character!)
    }
    
}

extension JapaneseCharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return japanese.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let firstCharacterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCharacterCell", for: indexPath) as! FirstCharacterCell
        
        let row = indexPath.row
        
        firstCharacterCell.backgroundColor = .lightGray
        firstCharacterCell.layer.cornerRadius = 5
        
        firstCharacterCell.characterLabel.text = japanese[row].sound
        
        return firstCharacterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let characterList = japanese[row].letters
        let consonant = japanese[row].sound.lowercased()

        
        for i in 0..<characterList.count {
            labels[i].text = nil
            if characterList[i] != "　" {
                labels[i].text = characterList[i]
                if consonant != "vowel" {
                    soundsLabels[i].text = consonant + vowels[i]
                } else {
                    soundsLabels[i].text = vowels[i]
                }
            } else {
                childrenStackView.arrangedSubviews[i+1].isHidden = true
            }
        }

        parentsStackView.isHidden = false
//        collectionView.collectionViewLayout.invalidateLayout()
        
        animateView()
        
        collectionView.isUserInteractionEnabled = false
    }
    
}


