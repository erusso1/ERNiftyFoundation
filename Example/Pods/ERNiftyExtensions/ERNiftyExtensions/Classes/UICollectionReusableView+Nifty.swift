//
//  UICollectionReusableView+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UICollectionReusableView {
  
  @nonobjc public static var identifier:String {return self.classString}
  
  @nonobjc public static var nib:UINib? {return UINib(nibName: identifier, bundle: nil)}
}

