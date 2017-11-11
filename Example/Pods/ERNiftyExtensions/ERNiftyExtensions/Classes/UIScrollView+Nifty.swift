//
//  UIScrollView+Nifty.swift
//  ERNiftyExtensions
//
//  Created by Ephraim Russo on 10/1/17.
//

import UIKit

extension UIScrollView {
  
  public func scrollToBottomAnimated(_ animated: Bool) {
    
    let yOffset = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
    
    self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
  }
  
  public var isScrolledToBottom: Bool { let yOffset = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom; return self.contentOffset.y == yOffset  }
}


