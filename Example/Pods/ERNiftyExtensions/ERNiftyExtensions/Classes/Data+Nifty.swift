//
//  Data+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import CryptoSwift

extension Data {
  
  public var hexadecimal: String {
    var token: String = ""
    for i in 0 ..< self.count {
      token += String(format: "%02.2hhx", self[i] as CVarArg)
    }
    
    return token
  }
  
  public func encrptedAES(withKey key: String, iv: String) -> Data {
    
    let encrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](self))    
    return Data(encrypted)
  }
  
  public func decryptedAES(withKey key: String, iv: String) -> Data {
    
    let decrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](self))
    return Data(decrypted)
  }
}
