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
    if let char = characters { return input.characters.count >= char  ?  true : false }
    return true
  }
}

