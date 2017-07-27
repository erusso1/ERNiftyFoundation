//
//  Data+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension Data {
  
  public var hexadecimal: String {
    var token: String = ""
    for i in 0 ..< self.count {
      token += String(format: "%02.2hhx", self[i] as CVarArg)
    }
    
    return token
  }
}
