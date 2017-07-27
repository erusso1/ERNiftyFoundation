//
//  NSObject+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension NSObject {
  
  @nonobjc public static var classString:String {return "\(self)".components(separatedBy: ".").last!}
}
