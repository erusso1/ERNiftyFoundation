//
//  Array+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 6/5/17.
//
//

extension Array {
    
    /// Returns a random element from the array.
    public var random:Element {
        
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    /// Removes the passed element from the array if it exits.
    public mutating func remove<T: Equatable>(_ element: T) -> Element? {
       
        for (idx, objectToCompare) in enumerated() {if let to = objectToCompare as? T { if element == to {return self.remove(at: idx)} }
        }
        
        return nil
    }
}
