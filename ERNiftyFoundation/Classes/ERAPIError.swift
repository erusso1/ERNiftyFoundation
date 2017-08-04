//
//  ERAPIError.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation

public struct ERAPIError {
  
  public let details: String?
  
  public init(_ details: String?) { self.details = details }
}

extension ERAPIError: CustomStringConvertible {

  public var description: String { return details ?? "No details have been given." }
}
