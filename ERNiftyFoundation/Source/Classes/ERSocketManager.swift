//
//  ERWebSocket.swift
//  Pods
//
//  Created by Ephraim Russo on 8/3/17.
//
//

import Foundation
import AVFoundation
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
  
  fileprivate var audioPlayer: AVAudioPlayer?
  
  fileprivate var connectCompletionHandler: VoidCompletionHandler?
  
  //**************************************************//
  
  // MARK: Initialization
  
  init() {
    setupSocket()
    setupNotifications()
  }
  
  private func setupSocket() {
    
    guard let webSocketURL = ERAPIManager.environment.webSocketURL else {return}
    socket = WebSocket(url: webSocketURL)
    socket.delegate = self
  }
  
  private func setupNotifications() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(receivedApplicationWillResignActiveNotification(_:)), name: .UIApplicationWillResignActive, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(receivedApplicationDidBecomeActiveNotification(_:)), name: .UIApplicationDidBecomeActive, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(receivedApplicationWillTerminateNotification(_:)), name: .UIApplicationWillTerminate, object: nil)
  }
  
  //**************************************************//
  
  // MARK: Append Headers
  
  public func appendHeaders(headers: [String: String]) {
    
    
  }
  
  //**************************************************//
  
  // MARK: Sound
  
  public func applyNotificationSoundURL(_ url: URL) {
    
    self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
  }
  
  //**************************************************//
  
  // MARK: Connect
  
  public func connect(completion: VoidCompletionHandler?=nil) {
    connectCompletionHandler = completion
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
  
    public func websocketDidConnect(socket: WebSocketClient) {
        
        print("The web socket has connected.")
        
        shouldReconnect = true
        
        connectCompletionHandler?()
        connectCompletionHandler = nil
    }
  
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
        print("The web socket has disconnected.")
        
        if let errorDescription = error?.localizedDescription, errorDescription != "" {
            
            print("Error: \(errorDescription)")
        }
    }
  
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        print("The web socket has received a message: \(text)")
        
        audioPlayer?.play()
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
        print("The web socket has received data: \(data)")
    }
}

extension ERSocketManager {
  
  @objc internal func receivedApplicationWillResignActiveNotification(_ notification: Notification) {
    
    disconnect()
  }
  
  @objc internal func receivedApplicationDidBecomeActiveNotification(_ notification: Notification) {
    
    guard shouldReconnect else {return}
    
    shouldReconnect = false

    connect()
  }
  
  @objc internal func receivedApplicationWillTerminateNotification(_ notification: Notification) {
    
    disconnect()
  }
}
