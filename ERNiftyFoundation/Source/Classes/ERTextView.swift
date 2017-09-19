//
//  ERTextView.swift
//  Pods
//
//  Created by Ephraim Russo on 7/26/17.
//
//

import Foundation
import ERNiftyExtensions

public class ERTextView: UITextView {

  public override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func configureFor(termsOfUseURL: URL, privacyPolicyURL: URL) {
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    paragraphStyle.alignment = .center
    
    let string = NSMutableAttributedString(string: "By continuing I agree to the Template terms of use and privacy policy.", attributes: [.paragraphStyle : paragraphStyle, .foregroundColor : UIColor.lightGray])
    
    string.setAsLink(textToFind: "terms of use", linkURL: termsOfUseURL)
    
    string.setAsLink(textToFind: "privacy policy", linkURL: privacyPolicyURL)
    
    self.attributedText = string
    
    self.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.lightGray, NSAttributedStringKey.underlineStyle.rawValue : NSUnderlineStyle.styleSingle.rawValue]
  }
}
