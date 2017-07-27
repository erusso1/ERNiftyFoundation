//
//  UILabel+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UILabel {
  
  /// Sets the passed `text` using a fading transition. Default duration is 0.35s.
  public func setTextAnimated(_ text:String?, duration:TimeInterval=0.25) {
    
    let animation = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.type = kCATransitionFade
    animation.duration = duration
    self.layer.add(animation, forKey: "kCATransitionFade")
    self.text = text
  }
}

