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
  
  static func getAllPosts() {
    
    let endpoint = ERAPIEndpoint(components: .posts, .id("wefiblwenglk3j4nrglkwerng"))
    
    ERAPIManager.request(on: endpoint) { (post: User?, error) in
      
      guard let post = post else {return}
      print("Here is the post - ID: \(post)  Content: \(post)")
    }
  }
  
  //**************************************************//
}

extension ERAPIPathComponent {
  
  public static var posts: ERAPIPathComponent { return "posts" }

}
