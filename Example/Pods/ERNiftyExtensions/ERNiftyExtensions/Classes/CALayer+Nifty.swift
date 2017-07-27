//
//  CALayer+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 6/5/17.
//
//

extension CALayer {
    
    /// Returns a sublayer of the receiver if one exists with the given `name`.
    public func sublayer(withName name:String) -> CALayer? {
     
        guard let sublayers = self.sublayers else {return nil}
        
        for layer in sublayers { if layer.name == name { return layer } }

        return nil
    }
}
