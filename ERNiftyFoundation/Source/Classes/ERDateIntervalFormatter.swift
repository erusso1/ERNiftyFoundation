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
    
    public init() {
        
    }
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

extension UnboxFormatter {
    
    public static var milliseconds: ERDateIntervalFormatter {
        
        ERDateIntervalFormatter.formatterType = .milliseconds
        
        return ERDateIntervalFormatter()
    }
    
    public static var seconds: ERDateIntervalFormatter {
        
        ERDateIntervalFormatter.formatterType = .seconds

        return ERDateIntervalFormatter()
    }
}
