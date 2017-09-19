//
//  String+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import Foundation

extension String {
  
  /// Returns a new `String` representation of the receiver in base-64 encoded format.
  public var base64EncodedString: String? {return self.data(using: String.Encoding.utf8)?.base64EncodedString()}
  
  /// Returns the receiver's number of characters.
  public var length: Int {return Int(self.characters.count)}
  
  /// Returns a `true` if the receiver is in email format.
  public var isEmail: Bool {
    guard let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive) else {return false}
    return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.length)) != nil
  }
  
  /// Returns the decimal representation.
  public var decimal:Double? {
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.number(from: self)?.doubleValue
  }
  
  /// Returns the height of the bounding width using the specified font.
  public func heightFromBoundedWidth(_ width:CGFloat, font:UIFont) -> CGFloat {
    
    let minHeight = font.pointSize + 4
    
    let maxHeight = ceil((self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(Int.max)), options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil).height + 8.0)
    
    return max(maxHeight, minHeight)
  }
  
  public func substringSeparatedBy(separator: String) -> String? {
    if let substring = self.components(separatedBy: separator).last {
      return substring
    }
    return ""
  }
  
  /// Returns the character at the given index.
  public subscript (index: Int) -> Character {
    return self[self.characters.index(self.startIndex, offsetBy: index)]
  }
}
