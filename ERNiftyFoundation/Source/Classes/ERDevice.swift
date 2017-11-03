//
//  ERDevice.swift
//  Pods
//
//  Created by Ephraim Russo on 8/30/17.
//
//

import Foundation

public enum ERDevice {
  
  case iPhone4OrLess
  
  case iPhone5
  
  case iPhone6Or7
  
  case iPhone6Or7Plus
  
  case iPhoneX
  
  case iPad
  
  case unknown
  
  public static var isSimulator: Bool { return (TARGET_IPHONE_SIMULATOR != 0) }
  
  public static var isProduction: Bool {
    
    #if DEBUG
      return false
    #else
      return true
    #endif
  }
  
  public static var current: ERDevice {
    
    let idiom = UIDevice.current.userInterfaceIdiom
    
    switch idiom {
      
    case .phone:
      
      if ERScreenSize.maxLength < 568.0 { return .iPhone4OrLess }
      
      else if ERScreenSize.maxLength == 568.0 { return .iPhone5 }
      
      else if ERScreenSize.maxLength == 667.0 { return .iPhone6Or7 }
      
      else if ERScreenSize.maxLength == 736.0 { return .iPhone6Or7Plus }
        
      else if ERScreenSize.maxLength == 812.0 { return .iPhoneX }
      
      else { return .unknown }
      
    default: return .iPad
    }
  }
}
