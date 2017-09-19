//
//  NSMutableAttributedString+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/23/17.
//
//

import Foundation
import UIKit

extension NSMutableAttributedString {
  
  public func setAsLink(textToFind:String, linkURL:URL) {
    
    let foundRange = self.mutableString.range(of: textToFind)
    if foundRange.location != NSNotFound {
      self.addAttribute(.link, value: linkURL, range: foundRange)
    }
  }
}
