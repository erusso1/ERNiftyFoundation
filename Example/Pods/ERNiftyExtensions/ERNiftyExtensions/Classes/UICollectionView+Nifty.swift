//
//  UICollectionView+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UICollectionView {
  
  public func scrollToTopAnimated(_ animated:Bool) {self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: animated)}
  
  public func register(cellType:AnyClass) {
    guard let T = cellType as? UICollectionViewCell.Type else {return}
    self.register(T.nib, forCellWithReuseIdentifier: T.identifier)
  }
  
  public func register(supplementaryViewType:AnyClass, forKind kind:String) {
    guard let T = supplementaryViewType as? UICollectionReusableView.Type else {return}
    self.register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
  }
  
  public func dequeCell<T:UICollectionViewCell>(for indexPath:IndexPath) -> T {
    let v = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    return v
  }
  
  public func dequeSupplementaryView<T:UICollectionReusableView>(ofKind kind:String, for indexPath:IndexPath) -> T {
    let v = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier, for: indexPath) as! T
    return v
  }
}
