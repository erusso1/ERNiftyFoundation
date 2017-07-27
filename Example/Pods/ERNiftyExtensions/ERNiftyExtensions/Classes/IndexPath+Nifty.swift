//
//  IndexPath+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension IndexPath {
  
  public var description: String {
    return "Section: \((self as NSIndexPath).section) Item: \((self as NSIndexPath).item)"
  }
}
