////
////  ERAPNManager.swift
////  Pods
////
////  Created by Ephraim Russo on 9/4/17.
////
////
//
//import Foundation
//import UserNotifications
//
//public typealias APNSetupCompletionHandler = (ERAPNError?) -> Void
//
//public enum ERAPNError {
//
//  case unauthorized
//
//  case noDeviceToken
//
//  case networkError
//}
//
//public final class ERAPNManager {
//
//  //**************************************************//
//
//  // MARK: Singleton
//
//  public static let shared:ERAPNManager = {
//    return ERAPNManager()
//  }()
//
//  //**************************************************//
//
//  // MARK: Public Variables
//
//  //**************************************************//
//
//  // MARK: Private Variables
//
//  private var setupCompletionHandler: APNSetupCompletionHandler?
//
//  //**************************************************//
//
//  // MARK: Static Variables
//
//  //**************************************************//
//
//  // MARK: Setup
//
//  public func setup(options: UNAuthorizationOptions=[.alert, .badge, .sound], completion:
//    APNSetupCompletionHandler?=nil) {
//
//    UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
//
//      guard granted else {completion?(.unauthorized); return}
//
//      self.setupCompletionHandler = completion
//
//      UIApplication.shared.registerForRemoteNotifications()
//    }
//  }
//
//  public func teardown(completion: APNSetupCompletionHandler?=nil) {
//
//    disassociateAPNToken()
//  }
//
//  //**************************************************//
//
//  // MARK: Completed APN Setup
//
//  public func registeredForAPN(deviceToken: Data?) {
//
//    guard let deviceToken = deviceToken else { self.setupCompletionHandler?(.noDeviceToken);  return }
//
//    let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//
//    associate(token: deviceTokenString)
//  }
//
//  //**************************************************//
//
//  // MARK: Associate APN Token
//
//  fileprivate func associate(token:String) {
//
//    // TODO: Update token with BE here.
//
//    setupCompletionHandler?(nil)
//    setupCompletionHandler = nil
//  }
//
//  //**************************************************//
//
//  // MARK: Disssociate APN Token
//
//  fileprivate func disassociateAPNToken() {
//
//    // TODO: Remove token from BE here.
//
//    setupCompletionHandler?(nil)
//    setupCompletionHandler = nil
//  }
//
//  //**************************************************//
//}

