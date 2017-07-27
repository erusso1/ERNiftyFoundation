//
//  CLLocation+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

import CoreLocation

extension CLLocation {
  
  public func getAddress(completion:@escaping (String?)->Void) {
    
    let geoCoder = CLGeocoder()
    
    geoCoder.reverseGeocodeLocation(self) { placemarks, error in
      
      guard let placemark = placemarks?.first else {completion(nil); return}
      
      guard let thoroughfare = placemark.thoroughfare, let city = placemark.locality, let state = placemark.administrativeArea, let zipCode = placemark.postalCode else {completion(nil); return}
      
      let address = "\(thoroughfare), \(city), \(state), \(zipCode)"
      
      completion(address)
    }
  }
}

