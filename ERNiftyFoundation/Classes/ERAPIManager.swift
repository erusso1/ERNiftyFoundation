//
//  ERAPIManager.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire
import Unbox

fileprivate typealias ERAPIRequestHeaders = [String: String]

public typealias ERAPIJSONResponse = (JSONObject?, ERAPIError?) -> Void

public typealias ERAPIItemResponse<T:Unboxable> = (T?, ERAPIError?) -> Void

public typealias ERAPIMultipleResponse<T:Unboxable> = ([T]?, ERAPIError?) -> Void

//**************************************************//

// MARK: Declaration

public struct ERAPIManager { }

//**************************************************//

// MARK: Configuration

extension ERAPIManager {
  
  public static var developmentURLString: String!
  
  public static var developmentURL: URL? { return URL(string: developmentURLString) }
  
  public static var productionURLString: String!
  
  public static var productionURL: URL? { return URL(string: productionURLString) }
  
  fileprivate static var networkErrorMessage: String?
  
  public static func configureFor(development: String, production: String, networkErrorMessage message: String? = "Your network connection seems to be acting strange. Please try again.") {
    
    self.developmentURLString = development
    self.productionURLString = production
    self.networkErrorMessage = message
  }
}

//**************************************************//

// MARK: Environment

extension ERAPIManager {
  
  public static var environment: ERAPIEnvironment {
    
    #if DEBUG
      return .development
    #else
    return .production
    #endif
  }
  
  public static var baseURL: URL? { return environment == .development ? developmentURL : productionURL }
}

//**************************************************//

// MARK: Endpoints

extension ERAPIManager {
  
  public static func endpoint(components: ERAPIPathComponent...) -> ERAPIEndpoint {

    assert(baseURL != nil, "The base URL set for the \(environment.rawValue) environment is invalid. Please make sure to call `ERAPIManager.configureFor(development: _, production: _)` using a valid URL string for your API.")

    return ERAPIEndpoint(baseURL: baseURL!, components: components)
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
  
  public static func request(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIJSONResponse? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else {
        
        let error = ERAPIError(self.networkErrorMessage)
        
        response?(nil, error)
        
        return
      }
      
      let JSON = alamofireResponse.result.value as? JSONObject
      
      response?(JSON, nil)
    }
  }
  
  public static func request<T: Unboxable>(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIItemResponse<T>? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else {
        
        let error = ERAPIError(self.networkErrorMessage)
        
        response?(nil, error)
        
        return
      }
      
      let JSON = alamofireResponse.result.value as? JSONObject
      
      let unboxed: T? = JSON?.unboxedObject()
      
      response?(unboxed, nil)
    }
  }
  
  public static func request<T: Unboxable>(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIMultipleResponse<T>? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else {
        
        let error = ERAPIError(self.networkErrorMessage)
        
        response?(nil, error)
        
        return
      }
      
      let JSONs = alamofireResponse.result.value as? [JSONObject]
      
      let unboxed: [T]? = JSONs?.unboxedObjects()
      
      response?(unboxed, nil)
    }
  }
}

//**************************************************//

