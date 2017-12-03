//
//  LevelTrackerViewController.swift
//  Nukon
//
//  Created by Chris Mauldin on 12/2/17.
//  Copyright © 2017 Kaichi Momose. All rights reserved.
//

import UIKit

class LevelTrackerViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUpLayouts()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


//SET UP LAYOUT OF VIEWS PROGRAMMATICALLY
extension LevelTrackerViewController {
    
    func setUpLayouts() {
        
        //SET UP TOP CONTAINER VIEW THAT WILL HOLD ANIMATED STATUS BAR
        let topContainerView = UIView()
        topContainerView.backgroundColor = .blue
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)
            //Constraints
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            ]) 
        
        
        
        //SET UP MIDDLE CONTAINER VIEW THAT WILL HOLD ANIMATED STATUS BAR
        let middleContainerView = UIView()
        middleContainerView.backgroundColor = .yellow
        middleContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(middleContainerView)
            //Constraints
        NSLayoutConstraint.activate([
            middleContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            middleContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middleContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            middleContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            ])
        
        
        
        
        //SET UP MIDDLE CONTAINER VIEW THAT WILL HOLD ANIMATED STATUS BAR
        let bottomContainer = UIView()
        bottomContainer.backgroundColor = .red
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainer)
        //Constraints
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: middleContainerView.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}
