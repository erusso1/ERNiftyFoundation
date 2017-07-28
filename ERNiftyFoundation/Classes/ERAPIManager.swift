//
//  ERAPIManager.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire

fileprivate typealias ERAPIRequestHeaders = [String: String]

//**************************************************//

// MARK: Declaration

public struct ERAPIManager { }

//**************************************************//

// MARK: Configuration

extension ERAPIManager {
  
  public static func configureFor(networkErrorMessage message: String) {
    
    self.networkErrorMessage = message
  }
}

//**************************************************//

// MARK: Authorization

extension ERAPIManager {
  
  public static var authorizationToken: String?
  
  fileprivate static let authorizationTokenGenerationKey: String = "authorization_token_timestamp"
  
  fileprivate static var authorizationTokenGenerationDate: Date? {
    
    get {
      
      guard let timeInterval = UserDefaults.standard.value(forKey: authorizationTokenGenerationKey) as? TimeInterval else { return nil }
      
      return Date(timeIntervalSince1970: timeInterval)
    }
    
    set {
      
      UserDefaults.standard.setValue(newValue, forKey: authorizationTokenGenerationKey)
    }
  }
  
  fileprivate static var authorizationHeaders: ERAPIRequestHeaders? {
    
    guard let token = authorizationToken else { return nil }
    
    return ["x-access-token" : token]
  }
}

//**************************************************//

// MARK: Requests

extension ERAPIManager {
  
  fileprivate static var networkErrorMessage: String = "Your network connection seems to be acting strange. Please try again."
  
  public static func request(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { response in
      
      guard response.isSuccess else {
        
        let error = ERAPIError(self.networkErrorMessage)
        
        print(error)
        
        return
      }
    }
  }
}

//**************************************************//

