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
  
  public static func id(_ value: String) -> ERAPIPathComponent { return ERAPIPathComponent(value) }
}

extension ERAPIPathComponent: ExpressibleByStringLiteral {
  
  public init(stringLiteral value: String) { self.init(value) }
  
  public init(unicodeScalarLiteral value: String) { self.init(stringLiteral: value) }
  
  public init(extendedGraphemeClusterLiteral value: String) { self.init(stringLiteral: value) }
}
