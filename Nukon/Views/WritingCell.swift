//
//  WritingCell.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/09.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class WritingCell: UICollectionViewCell {

    //MARK: - Properties
    var japaneseType: JapaneseType!
    var shownCharacter: String!
    var totalNumberOfCharacter: Int!
    var currentNumber: Int!
    
    var sound: String!
    var order: Order!
    var judge = Judge.yet
    
    //Sound Properties
    var effects = SoundEffects()
    
    //to write line
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    //delegation
    weak var delegate: CharacterDelegate!
    
    //MARK: Outlets
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var modeSwitchSegment: UISegmentedControl!
    @IBOutlet weak var handwritingView: UIView!
    @IBOutlet weak var backBoardView: UIView!
    @IBOutlet weak var characterView: UIView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var horizontalDottedLine: UIView!
    @IBOutlet weak var varticalDottedLine: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var recognizeButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var limeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    var confortLevelButtons: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        handwritingView.clipsToBounds = true
        handwritingView.isMultipleTouchEnabled = true
        
        self.backBoardView.layer.cornerRadius = 10
        self.backBoardView.layer.shadowColor = UIColor.materialBeige.cgColor
        self.backBoardView.layer.shadowRadius = 15
        self.backBoardView.layer.shadowOpacity = 0.7
        
        path.miterLimit = -10
        
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        modeSwitchSegment.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                 for: .normal)
        modeSwitchSegment.layer.cornerRadius = 4
        
        clearButton.layer.cornerRadius = clearButton.frame.height/2
        clearButton.layer.borderColor = UIColor.redSun.cgColor
        clearButton.layer.borderWidth = 2
        
        recognizeButton.layer.cornerRadius = recognizeButton.frame.height/2
        recognizeButton.layer.borderColor = UIColor.redSun.cgColor
        recognizeButton.layer.borderWidth = 2
        
        recognizeButton.isHidden = true
        
        confortLevelButtons = [redButton, orangeButton, yellowButton, limeButton, greenButton]
        confortLevelButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height/2
        }
        
        disableJudgeButtons()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: handwritingView) {
            startPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: handwritingView) {
            
            touchPoint = point
        }
        
        path.move(to: startPoint)
        //        path.addLine(to: touchPoint)
        path.addCurve(to: touchPoint, controlPoint1: startPoint, controlPoint2: touchPoint)
        
        startPoint = touchPoint
        draw()
    }
    
    
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 5
        strokeLayer.strokeColor = UIColor.redSun.cgColor
        strokeLayer.path = path.cgPath
        handwritingView.layer.addSublayer(strokeLayer)
    }
    
    func clear() {
        path.removeAllPoints()
        handwritingView.layer.sublayers = nil
        handwritingView.setNeedsDisplay()
    }
    
    func updateLabels() {
        // updates all labels
        self.characterLabel.text = self.shownCharacter
        if self.shownCharacter.count > 1 {
            self.characterLabel.font = self.characterLabel.font.withSize(130)
        } else {
            self.characterLabel.font = self.characterLabel.font.withSize(250)
        }
        self.soundLabel.text = self.sound
        if order == .randomly {
            self.modeSwitchSegment.alpha = 0.0
            self.testView()
        }
    }
    
    func enableJudgeButtons() {
        self.confortLevelButtons.forEach { button in
            button.transform = CGAffineTransform.identity
            button.alpha = 1
            button.isEnabled = true
        }
    }
    
    func disableJudgeButtons() {
        self.confortLevelButtons.forEach { button in
            //            button.transform = CGAffineTransform(scaleX: 0, y: 0)
            button.alpha = 0.0
            button.isEnabled = false
        }
    }
    
    func recognizeHiragana(pixelBuffer: CVPixelBuffer) {
        let model = hiraganaModel3()
        do {
            let output = try model.prediction(image: pixelBuffer)
            if output.classLabel == self.shownCharacter {
                //color animation
                self.pulsate()
                //sound animation
                self.effects.sound(nil, .right, nil)
                self.fadeInJudgeButtons()
            } else {
                shakeCharacter()
            }
        } catch {
            print("this is because \(error)")
        }
    }
    
    func recognizeKatakana(pixelBuffer: CVPixelBuffer) {
        let model = katakanaModel()
        do {
            let output = try model.prediction(image: pixelBuffer)
            if output.classLabel == self.shownCharacter {
                //color animation
                self.pulsate()
                //sound animation
                self.effects.sound(nil, .right, nil)
                self.fadeInJudgeButtons()
            } else {
                shakeCharacter()
            }
        } catch {
            print("this is because \(error)")
        }
    }
    
    func testView() {
        characterLabel.isHidden = true
        horizontalDottedLine.isHidden = true
        varticalDottedLine.isHidden = true
        if self.japaneseType == .hiragana {
            if !sound.contains("ky") && !sound.contains("sh") && !sound.contains("ch") && !sound.contains("ny") && !sound.contains("hy") && !sound.contains("my") && !sound.contains("ry") && !sound.contains("gy") && !sound.contains("j") && !sound.contains("by") && !sound.contains("py") {
                recognizeButton.isHidden = false
            }
        } else if self.japaneseType == .katakana {
            if !sound.contains("g") && !sound.contains("z") && !sound.contains("d") && !sound.contains("j") && !sound.contains("b") && !sound.contains("p") && !sound.contains("ky") && !sound.contains("sh") && !sound.contains("ch") && !sound.contains("ny") && !sound.contains("hy") && !sound.contains("my") && !sound.contains("ry") && !sound.contains("gy") && !sound.contains("j") && !sound.contains("by") && !sound.contains("py"){
                recognizeButton.isHidden = false
            }
        }
    }
    
    func  practiceView() {
        characterLabel.isHidden = false
        horizontalDottedLine.isHidden = false
        varticalDottedLine.isHidden = false
        recognizeButton.isHidden = true
    }
    
    //MARK: - Animation
    func pulsate() {
        let pulseAnimation = CABasicAnimation(keyPath: "backgroundColor")
        let scaleUpAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.5
        scaleUpAnimation.duration = 0.5
        //        pulseAnimation.repeatCount = 1
        
        //        shakeAnimation.autoreverses = true
        pulseAnimation.autoreverses = true
        scaleUpAnimation.autoreverses = true
        
        scaleUpAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        pulseAnimation.toValue = UIColor.materialGreen.cgColor
        scaleUpAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        
        self.handwritingView.layer.add(pulseAnimation, forKey: "backgroundColor")
        self.handwritingView.layer.add(scaleUpAnimation, forKey: "transform")
        
    }
    
    //shakes chracterview
    func shakeCharacter() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.characterView.center.x - 10, y: self.characterView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.characterView.center.x + 10, y: self.characterView.center.y))
        
        self.characterView.layer.add(shakeAnimation, forKey: "position")
    }
    
    func fadeInJudgeButtons() {
        let enable = {
            self.enableJudgeButtons()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: [.curveEaseInOut, .allowUserInteraction], animations: enable, completion: nil)
    }
    
    func fadeOutJudgeButtons() {
        let unenable = {
            self.disableJudgeButtons()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity:0.7, options: .curveEaseInOut, animations: unenable, completion: nil)
    }
    
    func dissmissOrNextCharacter(){
        if currentNumber == totalNumberOfCharacter {
            delegate.dismissPracticeView()
        } else {
            switch self.order {
            case .orderly:
                delegate.orderCharacter()
            default:
                delegate.randomCharacter()
            }
            //switch to practice
            self.modeSwitchSegment.selectedSegmentIndex = 0
            self.practiceView()
            self.clear()
            
            self.fadeOutJudgeButtons()
        }
    }
    
    @IBAction func modeSwitched(_ sender: Any) {
        let mode = modeSwitchSegment.selectedSegmentIndex
        switch mode {
        case 1: //test
            self.testView()
        default: //practice
            self.practiceView()
        }
        self.clear()
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clear()
    }
    
    @IBAction func recognationButtonTapped(_ sender: Any) {
        handwritingView.backgroundColor = .black
        let resultImage = UIImage.init(view: handwritingView)
        guard let pixelBuffer = resultImage.pixelBuffer() else {return}
        switch self.japaneseType {
        case .hiragana:
            recognizeHiragana(pixelBuffer: pixelBuffer)
        case .katakana:
            recognizeKatakana(pixelBuffer: pixelBuffer)
        default:
            handwritingView.backgroundColor = .clear
            fadeInJudgeButtons()
            return
        }
        handwritingView.backgroundColor = .clear
        fadeInJudgeButtons()
    }
    

    @IBAction func redButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 0)
        self.dissmissOrNextCharacter()
    }
    
    
    @IBAction func orangeButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 1)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 2)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func limeButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 3)
        self.dissmissOrNextCharacter()
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        delegate.updateCoreData(confidence: 4)
        self.dissmissOrNextCharacter()
    }
}
