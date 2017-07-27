//
//  UITableViewCell+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UITableViewCell {
  
  @nonobjc public static var identifier:String {return self.classString}
  
  @nonobjc public static var nib:UINib? {return UINib(nibName: identifier, bundle: nil)}
  
  public var selectionColor: UIColor? {
    get {
      return selectedBackgroundView?.backgroundColor
    }
    set {
      let view = UIView()
      view.backgroundColor = newValue
      selectedBackgroundView = view
    }
  }
}
