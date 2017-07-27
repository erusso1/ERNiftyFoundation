//
//  ERAPIRoute.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire

public enum ERAPIRequestMethod {
  
  case get
  
  case post
  
  case put
  
  case delete
  
  case patch
  
  var alamofireMethod: HTTPMethod {
    
    switch self {
    case .get: return .get
    case .post: return .post
    case .put: return .put
    case .delete: return .delete
    case .patch: return .patch
    }
  }
}

public enum ERAPIParameterEncoding {
  
  case jsonBody
  
  case queryString
  
  var alamofireEncoding: ParameterEncoding {
    
    switch self {
    case .jsonBody: return JSONEncoding.default
    case .queryString: return URLEncoding.queryString
    }
  }
}

public struct ERAPIPathComponent {
  
  public let string: String
  
  fileprivate var pathValue: String { return "/" + string }
  
  public init(_ string: String) {
    
    self.string = string
  }
}

extension ERAPIPathComponent {
  
  public static var users: ERAPIPathComponent { return ERAPIPathComponent("users") }
  
  public static var tokens: ERAPIPathComponent { return ERAPIPathComponent("tokens") }
}

public struct ERAPIEndpoint {
  
  public let components:[ERAPIPathComponent]
  
  public init(components:ERAPIPathComponent...) {
    self.components = components
  }
  
  public var urlString:String { return self.components.reduce("http://google.com", {$0 + $1.pathValue}) }
  
  public var url: URL? { return URL(string: urlString) }
}
