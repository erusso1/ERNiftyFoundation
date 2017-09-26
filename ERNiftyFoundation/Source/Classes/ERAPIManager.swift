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

public typealias ERAPIStringResponse = (String?, Error?) -> Void

public typealias ERAPIJSONResponse = (JSONObject?, Error?) -> Void

public typealias ERAPIMultipleJSONResponse = ([JSONObject]?, Error?) -> Void

public typealias ERAPIModelResponse<T: ERModelType> = (T?, Error?) -> Void

public typealias ERAPIMultipleModelResponse<T: ERModelType> = ([T]?, Error?) -> Void

//**************************************************//

// MARK: Declaration

public struct ERAPIManager { }

//**************************************************//

// MARK: Configuration

extension ERAPIManager {
  
  fileprivate static var development: ERAPIEnvironment!
  
  fileprivate static var production: ERAPIEnvironment!
  
  fileprivate static let localHost = ERAPIEnvironment(type: .development, apiURL: "http://localhost:8080", webSocketURL: "ws://localhost:8080/ws")
  
  fileprivate static var networkErrorMessage: String?
  
  fileprivate static var usesLocalHost: Bool = false
  
  public static func configureFor(development: ERAPIEnvironment, production: ERAPIEnvironment, usesLocalHost: Bool = false, networkErrorMessage message: String? = "Your network connection seems to be acting strange. Please try again.") {
    
    self.development = development
    self.production = production
    self.usesLocalHost = usesLocalHost
    self.networkErrorMessage = message
  }
}

//**************************************************//

// MARK: Environment

extension ERAPIManager {
  
  public static var environment: ERAPIEnvironment {
    
    #if DEBUG
      
      if usesLocalHost { return localHost }
        
      else {
        assert(development != nil, "The development environment has not been set. Please make sure to call `ERAPIManager.configureFor(development: _, production: _`")
        return development
      }
    
    #else
      assert(production != nil, "The production environment has not been set. Please make sure to call `ERAPIManager.configureFor(development: _, production: _`")
    return production
    #endif
  }
}

//**************************************************//

// MARK: Endpoints

extension ERAPIManager {
  
  public static func endpoint(components: ERAPIPathComponent...) -> ERAPIEndpoint {

    return ERAPIEndpoint(baseURL: environment.apiURL, components: components)
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
      
      guard alamofireResponse.isSuccess else { response?(nil, alamofireResponse.error); return }

      let JSON = alamofireResponse.result.value as? JSONObject
      
      response?(JSON, nil)
    }
  }
  
  public static func request(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIStringResponse? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseString() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else { response?(nil, alamofireResponse.error); return }

      response?(alamofireResponse.result.value, alamofireResponse.error)
    }
  }
  
  public static func request(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIMultipleJSONResponse? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else { response?(nil, alamofireResponse.error); return }
      
      let JSONs = alamofireResponse.result.value as? [JSONObject]
      
      response?(JSONs, nil)
    }
  }
  
  public static func request<T: ERModelType>(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIModelResponse<T>? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else { response?(nil, alamofireResponse.error); return }
      
      let JSON = alamofireResponse.result.value as? JSONObject
      
      let unboxed: T? = JSON?.unboxedObject()
      
      response?(unboxed, nil)
    }
  }
  
  public static func request<T: ERModelType>(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ERAPIMultipleModelResponse<T>? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else { response?(nil, alamofireResponse.error); return }

      let JSONs = alamofireResponse.result.value as? [JSONObject]
      
      let unboxed: [T]? = JSONs?.unboxedObjects()
      
      response?(unboxed, nil)
    }
  }
  
  public static func request(on endpoint: ERAPIEndpoint, method: ERAPIRequestMethod = .get, parameters: JSONObject? = nil, encoding: ERAPIParameterEncoding = .jsonBody, response: ErrorCompletionHandler? = nil) {
    
    Alamofire.request(endpoint.urlString, method: method.alamofireMethod, parameters: parameters, encoding: encoding.alamofireEncoding, headers: authorizationHeaders).responseJSON() { alamofireResponse in
      
      guard alamofireResponse.isSuccess else { response?(alamofireResponse.error); return }
      
      response?(nil)
    }
  }
}

//**************************************************//

