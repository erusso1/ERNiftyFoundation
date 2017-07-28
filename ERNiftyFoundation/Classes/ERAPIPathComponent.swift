//
//  ERAPIPathComponent.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation

public struct ERAPIPathComponent {
  
  public let string: String
  
  internal var pathValue: String { return "/" + string }
  
  public init(_ string: String) {
    
    self.string = string
  }
}

extension ERAPIPathComponent {
  
  public static var users: ERAPIPathComponent { return ERAPIPathComponent("users") }
  
  public static var tokens: ERAPIPathComponent { return ERAPIPathComponent("tokens") }
}
