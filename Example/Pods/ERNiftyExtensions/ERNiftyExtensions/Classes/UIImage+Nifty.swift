//
//  UIImage+Nifty.swift
//  ERNiftyExtensions
//
//  Created by Ephraim Russo on 3/29/18.
//

import UIKit
import Foundation

extension UIImage {
    
    /// Returns a resized copy of the receiver according to the given `size`. By default, the `scale` is set to 1.0, meaning the dimensions of `size` will be in abolute pixels.
    public func resizedTo(_ size: CGSize, scale: CGFloat = 1) -> UIImage? {
    
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output;
    }
}
