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
}
