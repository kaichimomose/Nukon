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
        path.miterLimit = -10
        
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        modeSwitchSegment.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                 for: .normal)
        
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
        
        let lineDashPattern: [NSNumber] = [10, 5]
        let horisontalShapeLayer = CAShapeLayer()
        horisontalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        horisontalShapeLayer.lineWidth = 2
        horisontalShapeLayer.lineDashPattern = lineDashPattern
        let horisontalpath = CGMutablePath()
        horisontalpath.addLines(between: [CGPoint(x: 0, y: 0),
                                          CGPoint(x: horizontalDottedLine.bounds.maxX, y: 0)])
        horisontalShapeLayer.path = horisontalpath
        horizontalDottedLine.layer.addSublayer(horisontalShapeLayer)
        
        let varticalShapeLayer = CAShapeLayer()
        varticalShapeLayer.strokeColor = UIColor.lightGray.cgColor
        varticalShapeLayer.lineWidth = 2
        varticalShapeLayer.lineDashPattern = lineDashPattern
        let varticalpath = CGMutablePath()
        varticalpath.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: 0, y: varticalDottedLine.frame.height)])
        varticalShapeLayer.path = varticalpath
        varticalDottedLine.layer.addSublayer(varticalShapeLayer)
        
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
        strokeLayer.strokeColor = UIColor.white.cgColor
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
        self.soundLabel.text = self.sound
//        switch self.judge {
//        case .correct:
//            //color animation
//            self.pulsate()
//            //sound animation
//            self.effects.sound(nil, .right, nil)
//            self.fadeInJudgeButtons()
//        default:
//            self.handwritingView.backgroundColor = .clear
//        }
        
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
            self.modeSwitchSegment.selectedSegmentIndex = 0
            characterLabel.isHidden = false
            horizontalDottedLine.isHidden = false
            varticalDottedLine.isHidden = false
            recognizeButton.isHidden = true
            self.handwritingView.backgroundColor = .clear
            self.clear()
            self.fadeOutJudgeButtons()
        }
    }
    
    @IBAction func modeSwitched(_ sender: Any) {
        let mode = modeSwitchSegment.selectedSegmentIndex
        switch mode {
        case 1:
            characterLabel.isHidden = true
            horizontalDottedLine.isHidden = true
            varticalDottedLine.isHidden = true
            recognizeButton.isHidden = false
            self.handwritingView.backgroundColor = .black
        default:
            characterLabel.isHidden = false
            horizontalDottedLine.isHidden = false
            varticalDottedLine.isHidden = false
            recognizeButton.isHidden = true
            self.handwritingView.backgroundColor = .clear
        }
        self.clear()
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clear()
    }
    
    @IBAction func recognationButtonTapped(_ sender: Any) {
        let resultImage = UIImage.init(view: handwritingView)
        let pixelBuffer = resultImage.pixelBuffer()
        let model = hiraganaModel3()
        do {
            let output = try model.prediction(image: pixelBuffer!)
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
