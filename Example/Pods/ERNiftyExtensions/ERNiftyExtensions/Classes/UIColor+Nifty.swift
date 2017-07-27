//
//  UIColor+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UIColor {
  
  public class func withHex(_ hex: String, alpha: CGFloat) -> UIColor {
    
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    var hexInt:UInt32 = 0;
    
    // Create scanner
    let scanner = Scanner(string: hex)
    
    // Tell scanner to skip the # character
    scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
    scanner.scanHexInt32(&hexInt)
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    let color = UIColor(red: CGFloat((hexInt & 0xFF0000) >> 16)/255, green: CGFloat((hexInt & 0xFF00) >> 8)/255, blue: CGFloat(hexInt & 0xFF)/255, alpha: alpha)
    
    return color;
  }
}

