//
//  ERModelType.swift
//  Pods
//
//  Created by Ephraim Russo on 8/31/17.
//
//

import Unbox
import Wrap

public protocol ERModelType: Equatable, Unboxable, WrapCustomizable {
  
  /// Returns the unique identifier of the model object.
  var id: String { get }
  
  /// Returns the JSON dictionary representation of the model object. May return `nil` due to Wrap errors.
  var JSON: JSONObject? { get }
  
  /// Creates a new model object given the passed JSON argument. Call can throw Unbox errors.
  init(JSON: JSONObject) throws
}

extension ERModelType {

  public var JSON: JSONObject? {
  
    do { return try Wrap.wrap(self) }
    
    catch { printPretty("Cannot return JSON for \(self): \(error.localizedDescription)"); return nil }
  }
  
  public init(JSON: JSONObject) throws { try self.init(unboxer: Unboxer(dictionary: JSON)) }
}

public func ==<T: ERModelType>(lhs: T, rhs: T) -> Bool { return lhs.id == rhs.id }
