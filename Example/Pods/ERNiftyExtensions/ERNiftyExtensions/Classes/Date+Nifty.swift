//
//  Date+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 7/11/17.
//
//

extension Date {
  
  public static let ISOFormatter:DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return dateFormatter
  }()
  
  /// Returns a new `Date` object from unix time stamp.
  public static func from(_ timestamp: TimeInterval) -> Date { return Date(timeIntervalSince1970: timestamp) }
  
  public static func timestamp() -> Int { return Int(Date().timeIntervalSince1970) }
  
  /// Returns a new `Date` object using the passed ISO-8601 formatted `String`.
  public static func from(_ ISOString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return dateFormatter.date(from: ISOString)
  }
  
  /// Returns a new `String` representation of the receiver using the passed `format`.
  public func stringWithFormat(_ format: String, timeZone: TimeZone?=TimeZone.current) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = timeZone
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  /// Returns the receiver's ISO-8601 formatted `String` .
  public var ISOString: String {return stringWithFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: TimeZone(identifier: "GMT"))}
  
  /// Returns an easily legible `String` representation of the receiver.
  public var pretty: String {return stringWithFormat("EEEE, MMMM d hh:mm a")}
  
  /// Returns the `String` representation of the receiver's hour, minute, and AM/PM.
  public var time: String {return stringWithFormat("h:mm a")}
  
  /// Return the `String` representation of the receiver's time of day.
  public var timeOfDay: String {
    let calendar = Calendar.current
    let dateComponents = (calendar as NSCalendar).components(.hour, from: self)
    let hour = dateComponents.hour!
    switch hour {
    case 0..<12: return "Morning"
    case 12...16: return "Afternoon"
    default: return "Evening"
    }
  }
}

extension Date {
  
  /// Returns the amount of years from another date
  public func years(from date: Date) -> Int {
    return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
  }
  
  /// Returns the amount of months from another date
  public func months(from date: Date) -> Int {
    return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
  }
  
  /// Returns the amount of weeks from another date
  public func weeks(from date: Date) -> Int {
    return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
  }
  
  /// Returns the amount of days from another date
  public func days(from date: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
  }
  
  /// Returns the amount of hours from another date
  public func hours(from date: Date) -> Int {
    return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
  }
  
  /// Returns the amount of minutes from another date
  public func minutes(from date: Date) -> Int {
    return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
  }
  
  /// Returns the amount of seconds from another date
  public func seconds(from date: Date) -> Int {
    return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
  }
}

extension Date {
  
  public var milisecondsSince1970: Int { return Int(self.timeIntervalSince1970*1000.0.rounded()) }
}
