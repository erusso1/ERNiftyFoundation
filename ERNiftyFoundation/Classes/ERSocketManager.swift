//
//  ERWebSocket.swift
//  Pods
//
//  Created by Ephraim Russo on 8/3/17.
//
//

import Foundation
import Starscream

//**************************************************//

public final class ERSocketManager {
  
  //**************************************************//
  
  // MARK: Singleton
  
  public static let shared:ERSocketManager = {
    return ERSocketManager()
  }()
  
  //**************************************************//
  
  // MARK: Public Variables
  
  public var isConnected: Bool { return socket.isConnected }
  
  //**************************************************//
  
  // MARK: Private Variables
  
  private var socket: WebSocket!
  
  internal var shouldReconnect: Bool = false
  
  //**************************************************//
  
  // MARK: Initialization
  
  init() {
    setupSocket()
    setupNotifications()
  }
  
  private func setupSocket() {
    
    socket = WebSocket(url: ERAPIManager.environment.webSocketURL)
    socket.headers = ["Authorization" : "some-hashed-token"]
    socket.delegate = self
  }
  
  private func setupNotifications() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(receivedApplicationWillResignActiveNotification(_:)), name: .UIApplicationWillResignActive, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(receivedApplicationDidBecomeActiveNotification(_:)), name: .UIApplicationDidBecomeActive, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(receivedApplicationWillTerminateNotification(_:)), name: .UIApplicationWillTerminate, object: nil)
  }
  
  //**************************************************//
  
  // MARK: Connect
  
  public func connect() {
    socket.connect()
  }
  
  //**************************************************//
  
  // MARK: Disconnect
  
  public func disconnect() {
    socket.disconnect()
  }

  //**************************************************//
}

extension ERSocketManager: WebSocketDelegate {
  
  public func websocketDidConnect(socket: WebSocket) {
   
    print("The web socket has connected to \(socket.currentURL)")
    shouldReconnect = true
  }
  
  public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    
    print("The web socket has disconnected from \(socket.currentURL)")
    
    if let errorDescription = error?.localizedDescription, errorDescription != "" {
      
      print("Error: \(errorDescription)")
    }
  }
  
  public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    
    print("The web socket as received a message: \(text)")
  }
  
  public func websocketDidReceiveData(socket: WebSocket, data: Data) {
    
    print("The web socket has received data: \(data)")
  }
}

extension ERSocketManager {
  
  @objc internal func receivedApplicationWillResignActiveNotification(_ notification: Notification) {
    
    disconnect()
  }
  
  @objc internal func receivedApplicationDidBecomeActiveNotification(_ notification: Notification) {
    
    guard shouldReconnect else {return}
    
    connect()
    
    shouldReconnect = false
  }
  
  @objc internal func receivedApplicationWillTerminateNotification(_ notification: Notification) {
    
    disconnect()
  }
}
