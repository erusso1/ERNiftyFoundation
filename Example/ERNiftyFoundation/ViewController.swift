//
//  ViewController.swift
//  ERNiftyFoundation
//
//  Created by erusso1 on 07/26/2017.
//  Copyright (c) 2017 erusso1. All rights reserved.
//

import UIKit
import ERNiftyFoundation
import Unbox

class LogInViewController: UIViewController {
  
  //**************************************************//
  
  // MARK: Static Variables
  
  //**************************************************//
  
  // MARK: Public Variables
  
  //**************************************************//
  
  // MARK: Private Variables
  
  private let strings = [
    "Discover new people with the music you love.",
    "Meet like-minded personalities.",
    "Stream together with Apple Music.",
    "Share playlists for every occassion.",
    "Log in and let's get started."
  ]
  
  private let fadeDuration: TimeInterval = 0.6
  
  //**************************************************//
  
  // MARK: Computed Variables
  
  //**************************************************//
  
  // MARK: Manager
  
  //**************************************************//
  
  // MARK: IBOutlets
  
  @IBOutlet fileprivate weak var label: UILabel!
  
  @IBOutlet fileprivate weak var termsTextView: ERTextView!
  
  //**************************************************//
  
  // MARK: IBActions
  
  //**************************************************//
  
  // MARK: View Loading
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    loadStrings()
    
    fadeInContainerView()
  }
  
  private func loadStrings() {
    
    func loadSubtitle() {
      
      label.text = strings.first
    }
    
    func loadTerms() {
      
      termsTextView.configureFor(termsOfUseURL: URL(string: "http://natgeo.com")!, privacyPolicyURL: URL(string: "http://nshipster.com")!)
    }
    
    loadSubtitle()
    
    loadTerms()
  }
  
  private func fadeInContainerView() {
    
    guard let container = self.view.viewWithTag(1) else {return}
    
    guard let bottom = self.view.viewWithTag(2) else {return}
    
    container.alpha = 0
    
    bottom.alpha = 0
    
    self.label.alpha = 0
    
    UIView.animate(withDuration: 6*self.fadeDuration, delay: 0.0, options: .curveEaseInOut, animations: {
      
      container.alpha = 1
      
    }) { _ in
      
      UIView.animate(withDuration: self.fadeDuration, animations: {
        
        bottom.alpha = 1
        
        self.label.alpha = 1
        
      }) { _ in
        
        self.beginSlideShow()
      }
    }
  }
  
  private func beginSlideShow() {
    
    let displayInterval: TimeInterval = 4.0
    
    for (index, string) in self.strings.enumerated() {
      
      afterDelay(Double(index)*displayInterval) { [weak self] in
        
        self?.label.setTextAnimated(string, duration: 1.0)
      }
    }
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
  
  //**************************************************//
}

class Beast: Unboxable {
  
  init() {
    
  }
  
  required convenience init(unboxer: Unboxer) throws {
    self.init()
  }
}
