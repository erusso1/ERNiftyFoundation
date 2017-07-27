//
//  Tests.swift
//  ERNiftyFoundation
//
//  Created by Ephraim Russo on 7/27/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class SomeController: UIViewController {
  
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
  
  //**************************************************//
  
  // MARK: View Loading
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
