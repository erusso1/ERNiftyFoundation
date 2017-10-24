//
//  MainVIewController.swift
//  ERNiftyFoundation_Example
//
//  Created by Ephraim Russo on 10/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //**************************************************//
    
    // MARK: Static Variables
    
    //**************************************************//
    
    // MARK: Public Variables
    
    //**************************************************//
    
    // MARK: Private Variables
    
    //**************************************************//
    
    // MARK: Computed Variables
    
    //**************************************************//
    
    // MARK: Manager
    
    //**************************************************//
    
    // MARK: IBOutlets
    
    //**************************************************//
    
    // MARK: IBActions
    
    @IBAction func showButtonPressed(_ sender: UIButton) {
        
        guard let containerVC: MTLCardModalContainerViewController = MTLCardModalContainerViewController.fromNib() else {return}
     
        let redVC = UIStoryboard.named("Main").instantiateViewController(withIdentifier: "RedViewController")
        
        containerVC.embedViewController(controller: redVC)
        
        self.present(containerVC, animated: true, completion: nil)
    }
    
    //**************************************************//
    
    // MARK: View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.cornerRadius = 10
    }
    
    //**************************************************//
    
    // MARK: View Appearance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //**************************************************//
    
    // MARK: Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Override point to pass data to the destination view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    //**************************************************//
    
    // MARK: View Disappearance
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Override point to customize time before presentation or push.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Override point to customize time after presentation or push.
    }
    
    //**************************************************//
    
    // MARK: Configuration
    
    override var prefersStatusBarHidden: Bool { return true }
    
    //**************************************************//
}
