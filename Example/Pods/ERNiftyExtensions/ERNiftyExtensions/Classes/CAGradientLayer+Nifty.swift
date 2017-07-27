//
//  CAGradientLayer+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 6/5/17.
//
//

extension CAGradientLayer {
    
    @nonobjc public static func from(colors:[UIColor]) -> CAGradientLayer {
        
        let colors = colors.map({$0.cgColor})        
        let maskLayer = CAGradientLayer()
        maskLayer.colors = colors
        return maskLayer
    }
}
