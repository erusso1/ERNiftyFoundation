//
//  ERAPIRequestMethod.swift
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
