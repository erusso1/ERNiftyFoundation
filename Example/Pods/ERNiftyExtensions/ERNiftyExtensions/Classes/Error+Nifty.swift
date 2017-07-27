//
//  Error+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension Error {
  
  public var userDescription: String? {
    guard let userInfo = _userInfo as? Dictionary<String, String>,
      let message = userInfo["message"]
      else {
        return localizedDescription
    }
    
    return message
  }
}
