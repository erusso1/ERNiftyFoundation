//
//  ERTargetMode.swift
//  Pods
//
//  Created by Ephraim Russo on 8/30/17.
//
//

import Foundation

public struct EREnvironment {
  
  public static let isSimulator = (TARGET_IPHONE_SIMULATOR != 0)
  
  public static var isProduction:Bool {
    
    #if DEBUG
      return false
    #else
      return true
    #endif
  }
}
