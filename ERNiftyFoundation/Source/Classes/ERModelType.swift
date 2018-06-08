//
//  ERModelType.swift
//  Pods
//
//  Created by Ephraim Russo on 8/31/17.
//
//

import Unbox
import Wrap

public protocol ERModelType: Equatable, Unboxable, WrapCustomizable, CustomDebugStringConvertible {
  
  /// Returns the unique identifier of the model object.
  var id: String { get }
  
  /// Returns the JSON dictionary representation of the model object. May return `nil` due to Wrap errors.
  var JSON: JSONObject? { get }
  
  /// Creates a new model object given the passed JSON argument. Call can throw Unbox errors.
  init(JSON: JSONObject) throws
}

extension ERModelType {

  /// Returns the JSON dictionary computed by the `Wrap` framework. The encoded keys are determined by the `wrapKeyStyle` property, with a default set to `matchPropertyName`.
  public var JSON: JSONObject? {
  
    do { return try Wrap.wrap(self) }
    
    catch { printPretty("Cannot return JSON for model with id: \(id) - error: \(error.localizedDescription)"); return nil }
  }
  
  /// Creates a new model object by unboxing the passed `JSON` dictionary.
  public init(JSON: JSONObject) throws { try self.init(unboxer: Unboxer(dictionary: JSON)) }
}

public func ==<T: ERModelType>(lhs: T, rhs: T) -> Bool { return lhs.id == rhs.id }

extension ERModelType {
  
  public var debugDescription: String {
    
    if let json = self.JSON {
      
      let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
      return string as String
    }
      
    else { return "\(self)" }
  }
}

extension ERModelType {
  
  /// The key style encoding type used by the `Wrap` framework. Default is set to `.matchPropertyName`.
  public var wrapKeyStyle: WrapKeyStyle { return .matchPropertyName }
  
  public func wrap(propertyNamed propertyName: String, originalValue: Any, context: Any?, dateFormatter: DateFormatter?) throws -> Any? {
    
    guard let date = originalValue as? Date else {return nil}
    
    return ERDateIntervalFormatter.formatterType == .milliseconds ? Int(date.timeIntervalSince1970*1000.0.rounded()) : Int(date.timeIntervalSince1970.rounded())
  }
}
