//
//  ERAPIManager.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire

typealias ERAPIRequestHeaders = [String: String]

public struct ERAPIManager {
  
  //**************************************************//
  
  // MARK: Public Variables
  
  public static var authorizationToken: String?
  
  private static var authorizationHeaders: ERAPIRequestHeaders? {
    
    guard let token = authorizationToken else { return nil }
    
    return ["x-access-token" : token]
  }
  
  //**************************************************//
  
  // MARK: Static Variables
  
  //**************************************************//
  
  // MARK: Functions

  public static func request(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody) {

    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { response in
     
      
    }
  }
  
  //**************************************************//
}
