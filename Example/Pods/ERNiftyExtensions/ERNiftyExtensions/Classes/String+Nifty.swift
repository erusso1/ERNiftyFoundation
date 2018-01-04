//
//  String+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import Foundation
import CryptoSwift

extension String {
  
  /// Returns a new `String` representation of the receiver in base-64 encoded format.
  public var base64EncodedString: String? {return self.data(using: String.Encoding.utf8)?.base64EncodedString()}
  
  /// Returns the receiver's number of characters.
  public var length: Int {return Int(self.count)}
  
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
  
  public func widthFromBoundedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
    
    return (self as NSString).boundingRect(with: CGSize.init(width: CGFloat(Int.max), height: height), options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil).width
  }
  
  public func substringSeparatedBy(separator: String) -> String? {
    if let substring = self.components(separatedBy: separator).last {
      return substring
    }
    return ""
  }
  
  /// Returns the character at the given index.
  public subscript (index: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: index)]
  }
}

extension UnicodeScalar {
  
  fileprivate var isEmoji: Bool {
    
    switch value {
    case 0x1F600...0x1F64F, // Emoticons
    0x1F300...0x1F5FF, // Misc Symbols and Pictographs
    0x1F680...0x1F6FF, // Transport and Map
    0x2600...0x26FF,   // Misc symbols
    0x2700...0x27BF,   // Dingbats
    0xFE00...0xFE0F,   // Variation Selectors
    0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
    65024...65039, // Variation selector
    8400...8447: // Combining Diacritical Marks for Symbols
      return true
      
    default: return false
    }
  }
  
   fileprivate var isZeroWidthJoiner: Bool {
    
    return value == 8205
  }
}

extension String {
  
  public var glyphCount: Int {
    
    let richText = NSAttributedString(string: self)
    let line = CTLineCreateWithAttributedString(richText)
    return CTLineGetGlyphCount(line)
  }
  
  public var isSingleEmoji: Bool {
    
    return glyphCount == 1 && containsEmoji
  }
  
  public var containsEmoji: Bool {
    
    return unicodeScalars.contains { $0.isEmoji }
  }
  
  public var containsOnlyEmoji: Bool {
    
    return !isEmpty
      && !unicodeScalars.contains(where: {
        !$0.isEmoji
          && !$0.isZeroWidthJoiner
      })
  }
  
  // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
  // If anyone has suggestions how to improve this, please let me know
  public var emojiString: String {
    
    return emojiScalars.map { String($0) }.reduce("", +)
  }
  
  public var emojis: [String] {
    
    var scalars: [[UnicodeScalar]] = []
    var currentScalarSet: [UnicodeScalar] = []
    var previousScalar: UnicodeScalar?
    
    for scalar in emojiScalars {
      
      if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
        
        scalars.append(currentScalarSet)
        currentScalarSet = []
      }
      currentScalarSet.append(scalar)
      
      previousScalar = scalar
    }
    
    scalars.append(currentScalarSet)
    
    return scalars.map { $0.map{ String($0) } .reduce("", +) }
  }
  
 fileprivate var emojiScalars: [UnicodeScalar] {
    
    var chars: [UnicodeScalar] = []
    var previous: UnicodeScalar?
    for cur in unicodeScalars {
      
      if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
        chars.append(previous)
        chars.append(cur)
        
      } else if cur.isEmoji {
        chars.append(cur)
      }
      
      previous = cur
    }
    
    return chars
  }
  
  public func hashedPassword() -> String
  {
    func createHash(string: String) -> String {
      
      guard !string.isEmpty else {return ""}
      
      guard let data = string.data(using: .utf8) else {return ""}
      
      let digest = Digest.sha512(data.bytes)
      
      let output = digest.map({String(format: "%02x", $0)}).joined().uppercased()
      
      return output
    }
    
    return createHash(string: createHash(string: self))
  }
}
