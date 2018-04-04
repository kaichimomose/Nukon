//
//  WritingViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/04.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class WritingViewController: UIViewController {

    //MARK: Propaties
    
    //MARK: Outlets
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var modeSwitchSegment: UISegmentedControl!
    @IBOutlet weak var handwritingView: UIView!
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
    
    var button: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineDashPattern: [NSNumber] = [10, 3]
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = lineDashPattern
        let horisontalpath = CGMutablePath()
        horisontalpath.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: horizontalDottedLine.frame.width, y: 0)])

        shapeLayer.path = horisontalpath
        horizontalDottedLine.layer.addSublayer(shapeLayer)
        
//        let varticalpath = CGMutablePath()
//        varticalpath.addLines(between: [CGPoint(x: 0, y: 0),
//                                          CGPoint(x: 0, y: varticalDottedLine.frame.height)])
//        shapeLayer.path = varticalpath
//        varticalDottedLine.layer.addSublayer(shapeLayer)
        
        clearButton.layer.cornerRadius = clearButton.frame.height/2
        clearButton.layer.borderColor = UIColor.redSun.cgColor
        clearButton.layer.borderWidth = 2
        
        recognizeButton.layer.cornerRadius = recognizeButton.frame.height/2
        recognizeButton.layer.borderColor = UIColor.redSun.cgColor
        recognizeButton.layer.borderWidth = 2
        
        recognizeButton.isHidden = true
        
        button = [redButton, orangeButton, yellowButton, limeButton, greenButton]
        button.forEach { button in
            button.layer.cornerRadius = button.frame.height/2
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func modeSwitched(_ sender: Any) {
        let mode = modeSwitchSegment.selectedSegmentIndex
        switch mode {
        case 1:
            characterLabel.isHidden = true
            characterLabel.isHidden = true
            characterLabel.isHidden = true
            recognizeButton.isHidden = false
        default:
            characterLabel.isHidden = false
            horizontalDottedLine.isHidden = false
            varticalDottedLine.isHidden = false
            recognizeButton.isHidden = true
        }
    }
}
