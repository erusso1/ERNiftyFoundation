//
//  ERDateIntervalFormatter.swift
//
//  Created by Ephraim Russo on 10/24/17.
//

import Foundation
import Unbox

public enum ERDateIntervalFormatterType {
  
  case milliseconds
  
  case seconds
}

public struct ERDateIntervalFormatter {
    
    public static var formatterType: ERDateIntervalFormatterType = .milliseconds
}

extension ERDateIntervalFormatter: UnboxFormatter {
    
    public typealias UnboxRawValue = TimeInterval
    
    public typealias UnboxFormattedType = Date
    
    public func format(unboxedValue: TimeInterval) -> Date? {
        
        let interval: TimeInterval
      
        switch ERDateIntervalFormatter.formatterType {
        case .milliseconds: interval = (unboxedValue / 1000.0)
        case .seconds: interval = unboxedValue
        }
      
        return Date(timeIntervalSince1970: interval)
    }
}
