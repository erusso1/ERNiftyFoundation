//
//  Int+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension Int {
  
  public var commaSeparatedString:String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? ""
  }
  
  /// Returns a human readable currency string by taking the receiver as the number of cents USD.
  public var currencyString:String {return (Double(self)/100.0).currencyString}
  
  /// Returns a random integer between the closed range.
  public static func random(between range: CountableClosedRange<Int>) -> Int
  {
    var offset = 0
    
    if range.lowerBound < 0   // allow negative ranges
    {
      offset = Swift.abs(range.lowerBound)
    }
    
    let mini = UInt32(range.lowerBound + offset)
    let maxi = UInt32(range.upperBound + offset + 1)
    
    return Int(mini + arc4random_uniform(maxi - mini)) - offset
  }
}
