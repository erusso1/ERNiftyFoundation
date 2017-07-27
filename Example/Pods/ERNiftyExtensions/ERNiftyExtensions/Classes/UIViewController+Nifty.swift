//
//  UIViewController+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UIViewController {
  
  @nonobjc class public func fromNib<T : UIViewController>(_ nibNameOrNil: String? = nil) -> T {
    let v: T? = fromNib(nibNameOrNil)
    return v!
  }
  
  @nonobjc class public func fromNib<T : UIViewController>(_ nibNameOrNil: String? = nil) -> T? {
    var view: T?
    let name: String
    if let nibName = nibNameOrNil {
      name = nibName
    } else {
      // Most nibs are demangled by practice, if not, just declare string explicitly
      name = self.classString
    }
    let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
    for v in nibViews! {
      if let tog = v as? T {
        view = tog
      }
    }
    return view
  }
  
  @nonobjc class public func fromStoryboard<T : UIViewController>(_ storyboard: UIStoryboard) -> T {
    let v: T? = fromStoryboard(storyboard)
    return v!
  }
  
  @nonobjc class public func fromStoryboard<T : UIViewController>(_ storyboard: UIStoryboard) -> T? {
    let v:T? = storyboard.viewController(withIdentifier: T.classString)
    return v
  }
  
  public func presentSettingsAlertWithTitle(_ title: String, message: String) {
    
    let alertController = UIAlertController( title: title, message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
      
      guard let url = URL(string: UIApplicationOpenSettingsURLString) else {return}
      
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    alertController.addAction(cancelAction)
    
    alertController.addAction(openAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  public func presentErrorAlert(title:String="An Error Occurred", message:String="We weren't able to process your request. Please try again.", completion:(()->Void)?=nil) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { _ in completion?() }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  public func presentCallAlertWith(phone:String) {
    
    let controller = UIAlertController(title: "Call \(phone)", message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let callAction = UIAlertAction(title: "Call", style: .default) { _ in
      guard let url = URL(string: "tel:\(phone)") else {return}
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    controller.addAction(cancelAction)
    controller.addAction(callAction)
    self.present(controller, animated: true, completion: nil)
  }
}
