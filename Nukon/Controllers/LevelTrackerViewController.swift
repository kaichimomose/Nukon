//
//  LevelTrackerViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 12/2/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

@IBDesignable class LevelTrackerViewController: UIViewController {
    
    let backgroundStageImageView: UIImageView = {
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "samurai"))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    
//    let stageOneImageView: UIImageView = {
//        let stageOneImage = UIImageView()
//    }()
    

    var levelNumber: UITextView = {
        var levelNumberString = UITextView()
        var level = 0
        let attributedText = NSMutableAttributedString(string: "LV: \(level)",
            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])

        levelNumberString.attributedText = attributedText
        levelNumberString.textAlignment = .center
        levelNumberString.translatesAutoresizingMaskIntoConstraints = false
        levelNumberString.backgroundColor = .clear
        levelNumberString.isEditable = false
        levelNumberString.isScrollEnabled = false
        return levelNumberString
    }()
    
//    let stageCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        layout.itemSize = CGSize(width: 100, height: 100)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
////        let numItems = stageCollection?.numberOfItems(inSection: 0)
//        collectionView.backgroundColor = .clear
////        stageCollection?.dataSource = collectionViewController
////        stageCollection?.delegate = collectionViewController
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isScrollEnabled = true
//        return collectionView
//
//    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayouts()
        
//        let stageCell = StageCell(frame: .zero)
//        stageCollectionView.register(StageCell.self, forCellWithReuseIdentifier: "Cell")
//        stageCollectionView.delegate = self
//        stageCollectionView.dataSource = self
    }

    

}

//extension LevelTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//
//        return cell
//    }
//
//
//}





//SET UP LAYOUT OF VIEWS PROGRAMMATICALLY
extension LevelTrackerViewController {
    
    func setUpLayouts() {
        view.addSubview(backgroundStageImageView)
        NSLayoutConstraint.activate([
            backgroundStageImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundStageImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundStageImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundStageImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        
        //SET UP TOP CONTAINER VIEW THAT WILL HOLD ANIMATED LEVEL BAR
        let topContainerView = UIView()
        topContainerView.backgroundColor = .clear
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundStageImageView.addSubview(topContainerView)
            //Top Container Constraints
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: backgroundStageImageView.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: backgroundStageImageView.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: backgroundStageImageView.trailingAnchor),
            topContainerView.heightAnchor.constraint(equalTo: backgroundStageImageView.heightAnchor, multiplier: 0.3)
            ])
            //SET UP ANIMATED LEVEL BAR VIEW
        let levelCounterView = LevelCounterView()
        levelCounterView.backgroundColor = .clear
        levelCounterView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(levelCounterView)
            //Level Bar View Constraints
        NSLayoutConstraint.activate([
            levelCounterView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            levelCounterView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            levelCounterView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 100),
            levelCounterView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -100),
            levelCounterView.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.72)
            ])
            //SET UP LEVEL NUMBER VIEW
        levelCounterView.addSubview(levelNumber)
            //Level Number View Constraints
        NSLayoutConstraint.activate([
            levelNumber.centerXAnchor.constraint(equalTo: levelCounterView.centerXAnchor),
            levelNumber.centerYAnchor.constraint(equalTo: levelCounterView.centerYAnchor),
            levelNumber.heightAnchor.constraint(equalTo: levelCounterView.heightAnchor, multiplier: 0.2),
            levelNumber.leadingAnchor.constraint(equalTo: levelCounterView.leadingAnchor, constant: 75),
            levelNumber.trailingAnchor.constraint(equalTo: levelCounterView.trailingAnchor, constant: -75)
            ])

        
        
        
        //SET UP MIDDLE CONTAINER VIEW THAT WILL HOLD STAGES
        let middleContainerView = UIView()
        middleContainerView.backgroundColor = .clear
        middleContainerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundStageImageView.addSubview(middleContainerView)
            //Constraints
        NSLayoutConstraint.activate([
            middleContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            middleContainerView.leadingAnchor.constraint(equalTo: backgroundStageImageView.leadingAnchor),
            middleContainerView.trailingAnchor.constraint(equalTo: backgroundStageImageView.trailingAnchor),
            middleContainerView.heightAnchor.constraint(equalTo: backgroundStageImageView.heightAnchor, multiplier: 0.35)
            ])
        //SET UP LEFT CONTAINER WITHIN THE MIDDLE CONTAINER
        let leftContainer = UIView()
        leftContainer.backgroundColor = .purple
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        middleContainerView.addSubview(leftContainer)
        NSLayoutConstraint.activate([
            leftContainer.topAnchor.constraint(equalTo: middleContainerView.topAnchor),
            leftContainer.leadingAnchor.constraint(equalTo: middleContainerView.leadingAnchor),
            leftContainer.widthAnchor.constraint(equalTo: middleContainerView.widthAnchor, multiplier: 0.35),
            leftContainer.bottomAnchor.constraint(equalTo: middleContainerView.bottomAnchor)
            ])
        
        //SET UP THE MIDDLE CONTAINER WITHIN THE MIDDLE CONTAINER
        let subMiddleContainer = UIView()
        subMiddleContainer.backgroundColor = .gray
        subMiddleContainer.translatesAutoresizingMaskIntoConstraints = false
        middleContainerView.addSubview(subMiddleContainer)
        NSLayoutConstraint.activate([
            subMiddleContainer.topAnchor.constraint(equalTo: middleContainerView.topAnchor),
            subMiddleContainer.leadingAnchor.constraint(equalTo: leftContainer.trailingAnchor),
            subMiddleContainer.widthAnchor.constraint(equalTo: middleContainerView.widthAnchor, multiplier: 0.31),
            subMiddleContainer.bottomAnchor.constraint(equalTo: middleContainerView.bottomAnchor)
            ])
        
        //SET UP RIGHT CONTAINER WITHIN THE MIDDLE CONTAINER
        let rightContainer = UIView()
        rightContainer.backgroundColor = .red
        rightContainer.translatesAutoresizingMaskIntoConstraints = false
        middleContainerView.addSubview(rightContainer)
        NSLayoutConstraint.activate([
            rightContainer.topAnchor.constraint(equalTo: middleContainerView.topAnchor),
            rightContainer.leadingAnchor.constraint(equalTo: subMiddleContainer.trailingAnchor),
            rightContainer.trailingAnchor.constraint(equalTo: middleContainerView.trailingAnchor),
            rightContainer.bottomAnchor.constraint(equalTo: middleContainerView.bottomAnchor)
            ])
//        //SET UP COLLECTION VIEW WITHIN MIDDLE CONTAINER
//        middleContainerView.addSubview(stageCollectionView)
//        NSLayoutConstraint.activate([
//            stageCollectionView.topAnchor.constraint(equalTo: middleContainerView.topAnchor),
//            stageCollectionView.leadingAnchor.constraint(equalTo: middleContainerView.leadingAnchor),
//            stageCollectionView.trailingAnchor.constraint(equalTo: middleContainerView.trailingAnchor),
//            stageCollectionView.bottomAnchor.constraint(equalTo: middleContainerView.bottomAnchor)
//            ])
        
        
        
        
        
        
        
        
        
        
//
//
        //SET UP  CONTAINER VIEW THAT WILL HOLD ANIMATED STATUS BAR
        let bottomContainer = UIView()
        bottomContainer.backgroundColor = .blue
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundStageImageView.addSubview(bottomContainer)
        //Constraints
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: middleContainerView.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: backgroundStageImageView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: backgroundStageImageView.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: backgroundStageImageView.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}
