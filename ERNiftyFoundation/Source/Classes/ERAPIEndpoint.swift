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
  
  private let components:[ERAPIPathComponent]
  
  private let baseURL: URL
  
  public init(baseURL: URL = ERAPIManager.environment.apiURL, components:ERAPIPathComponent...) {
    self.baseURL = baseURL
    self.components = components
  }
  
  public init(baseURL: URL = ERAPIManager.environment.apiURL, components: [ERAPIPathComponent]) {
    self.baseURL = baseURL
    self.components = components
  }
  
  public var urlString:String { return self.components.reduce(baseURL.absoluteString, {$0 + $1.pathValue}) }
  
  public var url: URL? { return URL(string: urlString) }
}

extension ERAPIEndpoint: CustomStringConvertible {
  
  public var description: String { return urlString }
}

extension ERAPIEndpoint: URLConvertible {
  
  public func asURL() throws -> URL {
    
    guard let url = self.url else { throw AFError.invalidURL(url: self.urlString) }
    
    return url
  }
}
