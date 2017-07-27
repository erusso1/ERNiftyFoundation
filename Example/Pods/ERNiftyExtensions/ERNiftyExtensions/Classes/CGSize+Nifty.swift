//
//  CGSize+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension CGSize {
  
  /// Reverses the `width` and `height` values.
  public mutating func reverse() {
    let width = self.width
    self.width = self.height
    self.height = width
  }
  
  /// Returns a new `CGSize` whose `width` and `height` values are opposite that of the receiver.
  public func reversed() -> CGSize {return CGSize(width: self.height, height: self.width)}
  
  /// Scales the `width` and `height` values by multiplying by the passed size's values.
  public mutating func scaleBy(_ size: CGSize) {
    self.width *= size.width
    self.height *= size.height
  }
  
  /// Returns a new `CGSize` whose `width` and `height` values are scaled by receiver's values.
  public func scaledBy(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width*self.width, height: size.height*self.height)
  }
}
