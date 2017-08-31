//
//  ERAPIParameterEncoding.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire

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
