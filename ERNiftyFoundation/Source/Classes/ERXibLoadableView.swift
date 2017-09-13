//
//  IBLoadableView.swift
//  VentureMe
//
//  Created by Ephraim Russo on 2/24/16.
//  Copyright © 2017 VentureMe Inc. All rights reserved.
//

import UIKit

open class ERXibLoadableView: UIView {
    
    //**************************************************//
    
    // MARK: Static Variables
    
    //**************************************************//
    
    // MARK: Public Variables
    
    //**************************************************//
    
    // MARK: Private Variables
    
    fileprivate var _view:UIView!
    
    //**************************************************//
    
    // MARK: Computed Variables
    
    /// The name of the .xib resource used to load the visual interface of the view. This property will always be computed as the String version of this view's class name.
    var nibName:String {return String(describing: type(of: self))}
    
    /// The view property that gets loaded directly by the Nib.
    public var view:UIView {
        if _view != nil {return _view}
        else {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: self.nibName, bundle: bundle)
            _view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            return _view
        }
    }
    
    //**************************************************//
    
    // MARK: Init
    
    public override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    public func xibSetup() {
        // use bounds not frame or it'll be offset
        self.view.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        // Make the view stretch with containing view
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Loads all subviews.
        self.loadSubviews()
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(view)
    }
    
    open func loadSubviews() {
        preconditionFailure("This function is intended to be overriden by subclasses!")
    }
    
    //**************************************************//
    
    // MARK: Configuration
    
    //**************************************************//
}
