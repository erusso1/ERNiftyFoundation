//
//  ERAPIError.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation

public enum ERAPIError: Error {
  
  case invalidAuthCredentials
  
  case networkFailure
  
  case unknown(details: String)
}

extension ERAPIError: CustomStringConvertible {

  public var description: String { return "API Error: \(self)" }
}
