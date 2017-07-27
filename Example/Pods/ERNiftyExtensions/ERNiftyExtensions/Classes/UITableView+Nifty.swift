//
//  UITableView+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import UIKit

extension UITableView {
  
  public func scrollToTopAnimated(_ animated:Bool) {self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)}
  
  public func register(cellType:AnyClass) {
    guard let T = cellType as? UITableViewCell.Type else {return}
    self.register(T.nib, forCellReuseIdentifier: T.identifier)
  }
  
  public func dequeCell<T:UITableViewCell>(for indexPath:IndexPath) -> T {
    let v = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    return v
  }
  
  public func removeFooterView() {
    tableFooterView = UIView()
  }
}
