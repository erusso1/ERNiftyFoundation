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
  
  /// The the line spacing to the passed `spacing` value in point. Only applies after the `text` property has been set.
  public func setLineSpacing(_ spacing: CGFloat) {
    
    guard let text = self.text else {return}
    
    let attributedString = NSMutableAttributedString(string: text)
    
    // *** Create instance of `NSMutableParagraphStyle`
    let paragraphStyle = NSMutableParagraphStyle()
    
    // *** set LineSpacing property in points ***
    paragraphStyle.lineSpacing = spacing
    
    // *** Apply attribute to string ***
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length-1))
    
    // *** Set Attributed String to your label ***
    self.attributedText = attributedString;
  }
  
  /// The the line spacing to the passed `spacing` value in point. Only applies after the `text` property has been set.
  public func setCharacterSpacing(_ spacing: CGFloat) {
    
    guard let text = self.text else {return}
    
    let attributedString = NSMutableAttributedString(string: text)
    
    // *** Apply attribute to string ***
    attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length-1))
    
    // *** Set Attributed String to your label ***
    self.attributedText = attributedString;
  }
}
