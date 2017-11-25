//
//  RecapViewController.swift
//  Nukon
//
//  Created by Kaichi Momose on 2017/11/11.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class RecapViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var choosenCharacters: [Japanese]?
    var characters = ""
    var generatedCharacters: [String: [(String, String)]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for listOfCharacters in choosenCharacters!{
            characters += "「" + listOfCharacters.letters.joined() + "」"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RecapViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return generatedCharacters!["wrong"]!.count
        }
        else {
            return generatedCharacters!["correct"]!.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JapaneseCharacterCell", for: indexPath) as! JapaneseCharactersCollectionViewCell
        let row = indexPath.row
        
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        if indexPath.section == 0 {
            cell.characterLabel.text = generatedCharacters!["wrong"]![row].0
        }
        else {
            cell.characterLabel.text = generatedCharacters!["correct"]![row].0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind.")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Recap", for: indexPath) as! RecapCollectionReusableView
        
        if indexPath.section == 0 {
            
            headerView.wrongOrCorrectLabel.text = "Wrong"
            headerView.layer.backgroundColor = UIColor.red.cgColor
            //headerView.profileImageView.backgroundColor = .red
            
            return headerView
        }
        else {
            
            headerView.wrongOrCorrectLabel.text = "Correct"
            headerView.layer.backgroundColor = UIColor.green.cgColor
            //headerView.profileImageView.backgroundColor = .red
            
            return headerView
        }
    }
}

extension RecapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}

