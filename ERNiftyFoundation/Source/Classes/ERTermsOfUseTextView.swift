//
//  ERTextView.swift
//  Pods
//
//  Created by Ephraim Russo on 7/26/17.
//
//

import Foundation
import ERNiftyExtensions

public class ERTermsOfUseTextView: UITextView {

  public override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    backgroundColor = nil
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func configureFor(termsOfUseURL: URL, privacyPolicyURL: URL, productName: String, textColor: UIColor = .black) {
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    paragraphStyle.alignment = .center
    
    let string = NSMutableAttributedString(string: "By continuing I agree to the \(productName) terms of use and privacy policy.", attributes: [.paragraphStyle : paragraphStyle, .foregroundColor : textColor])
    
    string.setAsLink(textToFind: "terms of use", linkURL: termsOfUseURL)
    
    string.setAsLink(textToFind: "privacy policy", linkURL: privacyPolicyURL)
    
    self.attributedText = string
    
    self.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.lightGray, NSAttributedStringKey.underlineStyle.rawValue : NSUnderlineStyle.styleSingle.rawValue]
  }
}
