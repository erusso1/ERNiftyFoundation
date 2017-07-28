//
//  SomeManager.swift
//  ERNiftyFoundation
//
//  Created by Ephraim Russo on 7/27/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import ERNiftyFoundation

struct SomeManager {
  
  //**************************************************//
  
  // MARK: Public Variables
  
  //**************************************************//
  
  // MARK: Static Variables
  
  //**************************************************//
  
  // MARK: Functions
  
  static func getAllUsers() {
    
    let endpoint = ERAPIEndpoint(components: .users)
    
    let parameters: JSONObject = [:]
    
    ERAPIManager.request(on: endpoint, parameters: parameters)
    
  }
  
  //**************************************************//
}
