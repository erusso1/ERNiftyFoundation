//
//  User.swift
//  ERNiftyFoundation
//
//  Created by Ephraim Russo on 8/4/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import ERNiftyFoundation
import Unbox
import Wrap

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

public final class User {
  
  public let id: String

  public let fullName: String
  
  init(id: String, fullName: String) {
    self.id = id
    self.fullName = fullName
  }
}

extension User: ERModelType {
  
  public var wrapKeyStyle: WrapKeyStyle { return .convertToSnakeCase }

  public convenience init(unboxer: Unboxer) throws {
    
    let id: String = try unboxer.unbox(key: "id")
    
    let fullName: String = try unboxer.unbox(key: "full_name")
    
    self.init(id: id, fullName: fullName)
  }
  
}
