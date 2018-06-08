//
//  ERAPIEnvironment.swift
//  Pods
//
//  Created by Ephraim Russo on 8/3/17.
//
//

import Foundation

public struct ERAPIEnvironment {
  
  public let apiURL: URL
  
  public init(apiURL: URL) {
    self.apiURL = apiURL
  }
  
  public init?(apiURL: String) {
    
    guard let apiURL = URL(string: apiURL) else { return nil }
    
    self.apiURL = apiURL

    }
}
