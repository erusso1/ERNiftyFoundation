//
//  UIPageViewController+Metal.swift
//  MetalPay
//
//  Created by Ephraim Russo on 8/29/17.
//  Copyright © 2017 Ephraim Russo. All rights reserved.
//

import UIKit

extension UIPageViewController {
    
    public var scrollView: UIScrollView? {
        
        for v in view.subviews {
            
            if v is UIScrollView {
                return v as? UIScrollView
            }
        }
        
        return nil
    }
}
