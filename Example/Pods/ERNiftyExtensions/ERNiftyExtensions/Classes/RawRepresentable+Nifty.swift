//
//  RawRepresentable+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import Foundation

extension RawRepresentable where Self.RawValue == Int {
  
  public static var count: Int {
    var max: Int = 0
    while let _ = Self.init(rawValue: max) { max += 1 }
    return max
  }
  
  public static var allValues : [Self] {
    
    var a:[Self] = []
    
    for i in 0..<count { if let value = Self.init(rawValue: i) {a.append(value)} }
    
    return a
  }
}
