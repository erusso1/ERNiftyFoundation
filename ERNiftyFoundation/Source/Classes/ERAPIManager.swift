//
//  ERAPIManager.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire
import CodableAlamofire
import AlamofireNetworkActivityLogger
import Unbox

//**************************************************//

// MARK: ERAPIResponseType

//**************************************************//

public typealias ERAPIStringResponse = (String?, Error?) -> Void

public typealias ERAPIJSONResponse = (JSONObject?, Error?) -> Void

public typealias ERAPIMultipleJSONResponse = ([JSONObject]?, Error?) -> Void

public typealias ERAPIModelResponse<T: ERModelType> = (T?, Error?) -> Void

public typealias ERAPIMultipleModelResponse<T: ERModelType> = ([T]?, Error?) -> Void

public typealias ERAPIDecodableResponse<T: Decodable> = (T?, Error?) -> Void

//**************************************************//

// MARK: Declaration

public struct ERAPIManager { }

//**************************************************//

// MARK: Configuration

extension ERAPIManager {
    
    public fileprivate(set) static var environment: ERAPIEnvironment!
    
    public fileprivate(set) static var customSessionManager: SessionManager?
    
    public static var requestParameterEncoder: JSONEncoder!
    
    public static var responseBodyDecoder: JSONDecoder!

    public static func configureFor(environment: ERAPIEnvironment, requestParameterEncoder: JSONEncoder = JSONEncoder(), responseBodyDecoder: JSONDecoder = JSONDecoder(), customSessionManager: SessionManager? = nil) {
        
        self.environment = environment
        self.customSessionManager = customSessionManager
        self.requestParameterEncoder = requestParameterEncoder
        self.responseBodyDecoder = responseBodyDecoder
    }
    
    public static var logsNetworkActivity: Bool = false {
        
        didSet {
            
            if logsNetworkActivity {
                
                NetworkActivityLogger.shared.level = .debug
                NetworkActivityLogger.shared.startLogging()
            }
                
            else { NetworkActivityLogger.shared.stopLogging() }
        }
    }
}

extension ERAPIManager {
    
    fileprivate static var sessionManager: SessionManager { return customSessionManager ?? SessionManager.default }
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
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseString(queue: utilityQueue) { alamofireResponse in
            
            response?(alamofireResponse.result.value, alamofireResponse.error)
        }
    }
    
    public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIJSONResponse? = nil) {
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: utilityQueue) { alamofireResponse in
            
            let JSON = alamofireResponse.result.value as? JSONObject
            
            response?(JSON, alamofireResponse.error)
        }
    }
    
    public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIMultipleJSONResponse? = nil) {
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: utilityQueue) { alamofireResponse in
            
            let JSONs = alamofireResponse.result.value as? [JSONObject]
            
            response?(JSONs, alamofireResponse.error)
        }
    }
    
    public static func request<T: ERModelType>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIModelResponse<T>? = nil) {
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: utilityQueue) { alamofireResponse in
            
            let JSON = alamofireResponse.result.value as? JSONObject
            
            let unboxed: T? = JSON?.unboxedObject()
            
            response?(unboxed, alamofireResponse.error)
        }
    }
    
    public static func request<T: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIDecodableResponse<T>? = nil) {
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseDecodableObject(queue: utilityQueue, decoder: responseBodyDecoder) { (alamofireResponse: DataResponse<T>)  in
            
            response?(alamofireResponse.result.value, alamofireResponse.result.error)
        }
    }
    
    public static func request<E: Encodable, T: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIDecodableResponse<T>? = nil) {
        
        let params: Parameters?
        
        do {
            
            let data = try requestParameterEncoder.encode(parameters)
            params = try JSONSerialization.jsonObject(with: data, options: []) as? Parameters
        }
        
        catch { response?(nil, AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))); return }
        
        self.request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, response: response)
    }
    
    public static func request<T: ERModelType>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ERAPIMultipleModelResponse<T>? = nil) {
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: utilityQueue) { alamofireResponse in
            
            let JSONs = alamofireResponse.result.value as? [JSONObject]
            
            let unboxed: [T]? = JSONs?.unboxedObjects()
            
            response?(unboxed, alamofireResponse.error)
        }
    }
    
    public static func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: ErrorCompletionHandler? = nil) {
        
        sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().response { alamofireResponse in
            
            response?(alamofireResponse.error)
        }
    }
}

//**************************************************//

