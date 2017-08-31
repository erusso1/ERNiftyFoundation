//
//  ERAPIEnvironment.swift
//  Pods
//
//  Created by Ephraim Russo on 8/3/17.
//
//

import Foundation

public enum ERAPIEnvironmentType: String {
  
  case development
  
  case production
}

public struct ERAPIEnvironment {

  public let type: ERAPIEnvironmentType
  
  public let apiURL: URL
  
  public let webSocketURL: URL
  
  public init(type: ERAPIEnvironmentType, apiURL: URL, webSocketURL: URL) {
    self.type = type
    self.apiURL = apiURL
    self.webSocketURL = webSocketURL
  }
  
  public init(type: ERAPIEnvironmentType, apiURL: String, webSocketURL: String) {
    self.type = type
    self.apiURL = URL(string: apiURL)!
    self.webSocketURL = URL(string: webSocketURL)!
  }
}
