//
//  UIStoryboard+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UIStoryboard {
  
  @nonobjc public static func named(_ name:String) -> UIStoryboard {return UIStoryboard(name: name, bundle: Bundle.main)}
  
  public func initialViewController<T:UIViewController>() -> T {
    return instantiateInitialViewController() as! T
  }
  
  public func viewController<T:UIViewController>(withIdentifier identifier:String) -> T? {
    return instantiateViewController(withIdentifier: identifier) as? T
  }
}
