//
//  PracticeViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2018/04/09.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController {

    //MARK: - Properties
    let speakingCellReuseIdentifer = "SpeakingCell"
    let writingCellReuseIdentifer = "WritingCell"
    let backgoundColor: UIColor = .hiraganaBackground
    
    //MARK: -Outlets
    @IBOutlet weak var menuBar: MenuBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = self.backgoundColor
        
        menuBar.practiceVC = self
        menuBarCollectionView.delegate = menuBar
        menuBarCollectionView.dataSource = menuBar
        menuBarCollectionView.backgroundColor = self.backgoundColor
        
        let selectedIndexpath = NSIndexPath(row: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexpath as IndexPath, animated: false, scrollPosition: [])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(UINib.init(nibName: "SpeakingCell", bundle: .main), forCellWithReuseIdentifier: speakingCellReuseIdentifer)
        collectionView.register(UINib.init(nibName: "WritingCell", bundle: .main), forCellWithReuseIdentifier: writingCellReuseIdentifer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollToItemIndexPath(menuindex: Int) {
        collectionView.reloadData()
        let indexPath = NSIndexPath(item: 0, section: menuindex)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
    
}

extension PracticeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: speakingCellReuseIdentifer, for: indexPath) as! SpeakingCell
            cell.backgroundColor = self.backgoundColor
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: writingCellReuseIdentifer, for: indexPath) as! WritingCell
            cell.backgroundColor = self.backgoundColor
            return cell
        }
    }
}
