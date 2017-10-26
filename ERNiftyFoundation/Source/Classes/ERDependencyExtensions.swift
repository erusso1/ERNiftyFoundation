//
//  ERDependencyExtensions.swift
//  Pods
//
//  Created by Ephraim Russo on 7/27/17.
//
//

import Foundation
import Alamofire
import Unbox

extension DataResponse {
  
  public var isSuccess: Bool { return self.error == nil }
}

extension Dictionary where Key == String, Value: Any {
  
  public func unboxedObject<T:Unboxable>() -> T? {
    
    var dic = JSONObject()
    
    for (key, value) in self { dic[key] = value }
    
    do {
        let object: T = try Unbox.unbox(dictionary: dic)
      return object
    }
      
    catch {
      print("*****************************************")
      print("")
      print("Error unboxing \(T.self) - Error: \(error) JSON: \(self)")
      print("")
      return nil
    }
  }
}

extension Sequence where Iterator.Element == UnboxableDictionary {
  
  public func unboxedObjects<T:Unboxable>() -> [T]? {
    
    guard let dics = self as? [UnboxableDictionary] else {return nil}
    
    do {
      
      let objects:[T] = try unbox(dictionaries: dics)
      return objects
    }
      
    catch {
      print("*****************************************")
      print("")
      print("Error unboxing \(T.self) - Error: \(error) JSON: \(self)")
      print("")
      return nil
    }
  }
  
  public func unboxedObjects<T: UnboxableWithContext>(with context: T.UnboxContext) -> [T]? {
    
    guard let dics = self as? [UnboxableDictionary] else {return nil}
    
    do {
      
      let objects:[T] = try unbox(dictionaries: dics, context: context)
      return objects
    }
      
    catch {
      print("*****************************************")
      print("")
      print("Error unboxing \(T.self) - Error: \(error) JSON: \(self)")
      print("")
      return nil
    }
  }
}

extension DateIntervalFormatter: UnboxFormatter {
  
  public typealias UnboxRawValue = TimeInterval
  
  public typealias UnboxFormattedType = Date
  
  public func format(unboxedValue: TimeInterval) -> Date? {
    
    return Date(timeIntervalSince1970: unboxedValue)
  }
}
