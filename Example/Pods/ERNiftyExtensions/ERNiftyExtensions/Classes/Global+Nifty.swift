//
//  Global+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import Foundation

public func randRange (_ lower: UInt32 , upper: UInt32) -> UInt32 {
  return lower + arc4random_uniform(upper - lower + 1)
}

public func afterDelay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

public func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
  var result = lhs
  rhs.forEach{ result[$0] = $1 }
  return result
}

public func += <K, V> (left: inout [K:V], right: [K:V]) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}
