//
//  ERAPIRoute.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire

public struct ERAPIEndpoint {
  
  public let components:[ERAPIPathComponent]
  
  public init(components:ERAPIPathComponent...) {
    self.components = components
  }
  
  public var urlString:String { return self.components.reduce("http://google.com", {$0 + $1.pathValue}) }
  
  public var url: URL? { return URL(string: urlString) }
}
