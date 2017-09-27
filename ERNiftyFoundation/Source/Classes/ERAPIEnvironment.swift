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
  
  public let webSocketURL: URL?
  
  public init(apiURL: URL, webSocketURL: URL? = nil) {
    self.apiURL = apiURL
    self.webSocketURL = webSocketURL
  }
  
  public init(apiURL: String, webSocketURL: String? = nil) throws {
    
    guard let apiURL = URL(string: apiURL) else { throw ERError.invalidApiURL}
    
    var webSocketInitURL: URL?

    if let string = webSocketURL { webSocketInitURL = URL(string: string) }
    
    self.apiURL = apiURL
    self.webSocketURL = webSocketInitURL
  }
}

extension ERAPIEnvironment {
  
  /// THe local host environment. It points the `apiURL` to `http://localhost:8080` and the webSocketURL to `ws://localhost:8080/ws`.
  public static func localHost() throws -> ERAPIEnvironment {
    
    return try ERAPIEnvironment(apiURL: "http://localhost:8080", webSocketURL: "ws://localhost:8080/ws")
  }
}
