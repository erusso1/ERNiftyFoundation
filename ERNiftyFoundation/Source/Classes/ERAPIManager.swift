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

//**************************************************//

// MARK: ERAPIResponseType

//**************************************************//

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
  
   public fileprivate(set) static var environment: ERAPIEnvironment!
  
  public static func configureFor(environment: ERAPIEnvironment) {
    
    self.environment = environment
  }
}

//**************************************************//

// MARK: Authorization

//extension ERAPIManager {
//
//  public static var authorizationToken: String?
//
//  fileprivate static let authorizationTokenGenerationKey: String = "authorization_token_timestamp"
//
//  fileprivate static var authorizationTokenGenerationDate: Date? {
//
//    get {
//
//      guard let timeInterval = UserDefaults.standard.value(forKey: authorizationTokenGenerationKey) as? TimeInterval else { return nil }
//
//      return Date(timeIntervalSince1970: timeInterval)
//    }
//
//    set {
//
//      UserDefaults.standard.setValue(newValue, forKey: authorizationTokenGenerationKey)
//    }
//  }
//
//  fileprivate static var authorizationHeaders: ERAPIRequestHeaders? {
//
//    guard let token = authorizationToken else { return nil }
//
//    return ["x-access-token" : token]
//  }
//}

//**************************************************//

// MARK: Requests

extension ERAPIManager {
  
  fileprivate static var utilityQueue: DispatchQueue { return .global(qos: .utility) }
}

extension ERAPIManager {

  public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIStringResponse? = nil) {

    Alamofire.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).responseString(queue: utilityQueue) { alamofireResponse in

      if logsNetworkResponses {
        print("*****************************************")
        print("")
        print(alamofireResponse.result.value?.debugDescription ?? "No string response")
        print("")
      }
      
      response?(alamofireResponse.result.value, alamofireResponse.error)
    }
  }
  
  public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIJSONResponse? = nil) {
    
    Alamofire.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(queue: utilityQueue) { alamofireResponse in
      
      if logsNetworkResponses {
        print("*****************************************")
        print("")
        print(alamofireResponse.result.value.debugDescription)
        print("")
      }
      
      let JSON = alamofireResponse.result.value as? JSONObject
      
      response?(JSON, alamofireResponse.error)
    }
  }

  public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIMultipleJSONResponse? = nil) {

    Alamofire.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(queue: utilityQueue) { alamofireResponse in

      if logsNetworkResponses {
        print("*****************************************")
        print("")
        print(alamofireResponse.result.value.debugDescription)
        print("")
      }
      
      let JSONs = alamofireResponse.result.value as? [JSONObject]

      response?(JSONs, alamofireResponse.error)
    }
  }

  public static func request<T: ERModelType>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIModelResponse<T>? = nil) {

    Alamofire.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(queue: utilityQueue) { alamofireResponse in

      if logsNetworkResponses {
        print("*****************************************")
        print("")
        print(alamofireResponse.result.value.debugDescription)
        print("")
      }
      
      let JSON = alamofireResponse.result.value as? JSONObject

      let unboxed: T? = JSON?.unboxedObject()

      response?(unboxed, alamofireResponse.error)
    }
  }

  public static func request<T: ERModelType>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIMultipleModelResponse<T>? = nil) {

    Alamofire.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(queue: utilityQueue) { alamofireResponse in

      if logsNetworkResponses {
        print("*****************************************")
        print("")
        print(alamofireResponse.result.value.debugDescription)
        print("")
      }
      
      let JSONs = alamofireResponse.result.value as? [JSONObject]

      let unboxed: [T]? = JSONs?.unboxedObjects()

      response?(unboxed, alamofireResponse.error)
    }
  }

  public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ErrorCompletionHandler? = nil) {

    Alamofire.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(queue: utilityQueue) { alamofireResponse in

      if logsNetworkResponses {
        print("*****************************************")
        print("")
        print(alamofireResponse.result.value.debugDescription)
        print("")
      }
      
      response?(alamofireResponse.error)
    }
  }
}

extension ERAPIManager {

  public static var logsNetworkResponses: Bool = false
}

//**************************************************//

