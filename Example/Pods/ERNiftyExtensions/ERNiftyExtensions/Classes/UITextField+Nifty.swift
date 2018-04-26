//
//  UITextField+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UITextField {
  
  /// Sets the passed `placehold` using the given `color`.
  public func setPlaceholder(_ placeholder:String, withColor color:UIColor) {self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : color])}
  
  public func validate(characters: Int? = nil) -> Bool {
    guard let input = self.text, input != "" else { return false }
    if let char = characters { return input.count >= char  ?  true : false }
    return true
  }

  public func setCharacterSpacing(_ spacing: CGFloat) {
    
    guard let text = self.text else {return}
    
    let attributedString = NSMutableAttributedString(string: text)
    
    // *** Apply attribute to string ***
    attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length-1))
    
    // *** Set Attributed String to your label ***
    self.attributedText = attributedString;
  }
}

