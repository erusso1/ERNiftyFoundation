//
//  ERScreenSize.swift
//  Pods
//
//  Created by Ephraim Russo on 8/30/17.
//
//

import Foundation

public struct ERScreenSize {
  
  public static let width = UIScreen.main.bounds.size.width
  
  public static let height = UIScreen.main.bounds.size.height
  
  public static let maxLength = max(width, height)

  public static let minLength = min(width, height)
}
