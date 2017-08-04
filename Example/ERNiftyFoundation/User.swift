//
//  User.swift
//  ERNiftyFoundation
//
//  Created by Ephraim Russo on 8/4/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Unbox

public final class Post: Unboxable {
  
  let content: String
  
  let id: String
  
  init(content: String, id: String) {
    self.content = content
    self.id = id
  }
  
  public convenience init(unboxer: Unboxer) throws {
    
    let content: String = try unboxer.unbox(key: "content")
    
    let id: String = try unboxer.unbox(key: "id")
    
    self.init(content: content, id: id)
  }
}
