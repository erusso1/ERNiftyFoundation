//
//  Double.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension Double {
  
  public func roundedTo(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
  
  public var currencyString:String {return "$" + decimalString}
  
  public var decimalString:String {return String(format: "%.02f", self)}
  
  /// Returns a random Double between the closed range.
  public static func random(between range: ClosedRange<Double>) -> Double
  { return Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max) * (range.upperBound - range.lowerBound) + range.lowerBound } }
