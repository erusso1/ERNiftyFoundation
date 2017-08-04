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
    
    let endpoint = ERAPIManager.endpoint(components: .posts, .id("oid:5982e7e20ade59030ade5903"))
    
    ERAPIManager.request(on: endpoint) { (post: Post?, error) in
      
      guard let post = post else {return}
      print("Here is the post - ID: \(post.id)  Content: \(post.content)")
    }
  }
  
  //**************************************************//
}

extension ERAPIPathComponent {
  
  public static var posts: ERAPIPathComponent { return ERAPIPathComponent("posts") }

}
