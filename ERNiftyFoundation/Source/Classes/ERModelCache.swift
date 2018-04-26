//
//  MTLCache.swift
//  MetalPay
//
//  Created by Ephraim Russo on 12/28/17.
//  Copyright © 2017 Metallicus Inc. All rights reserved.
//

import Foundation
import ERNiftyExtensions
import SwiftKeychainWrapper

public class ERModelCache {
  
  //**************************************************//
  
  // MARK: Static Variables
  
  public static var logsCaching = false
    
  public static var appGroupIdentifier: String? = nil
    
  public static let shared: ERModelCache = {
    
    let cache = ERModelCache()
    
    if FileManager.default.fileExists(atPath: cache.diskDirectoryURL.path) == false {
      
      do {
        
        try FileManager.default.createDirectory(at: cache.diskDirectoryURL, withIntermediateDirectories: false, attributes: nil)
        
        if ERModelCache.logsCaching { print("Successfully created the disk folder for ERModelCache") }
      }
        
      catch {  print("An error ocurred creating the disk folder for ERModelCache: \(error)") }
    }
  
    return cache
  }()
  
  //**************************************************//
  
  // MARK: Private Methods
  
  private func fileNameForType<T: ERModelType>(type: T.Type) -> String { return "\(T.self)" }
  
  private func diskURLForType<T: ERModelType>(type: T.Type) -> URL { return diskDirectoryURL.appendingPathComponent(fileNameForType(type: type)) }
 
  private var allMapsInMemory: [String : JSONObject] = [:]
  
  private func mapForType<T: ERModelType>(type: T.Type) -> JSONObject {
    
    let fileName = fileNameForType(type: type)
    
    // The map already exists in memory.
    if let dic = allMapsInMemory[fileName] {
      
      //if ERModelCache.logsCaching { printPretty("Loaded \(T.self) map from memory.") }
      
      return dic
    }
      
    // Check if the map exists on disk.
    else {
      
      let url = diskURLForType(type: type)
      
      if FileManager.default.fileExists(atPath: url.path) {
        
        guard let encrypted = try? Data(contentsOf: url) else {return [:]}
        
        guard let key = KeychainWrapper.standard.string(forKey: "\(fileName)-Disk-Key") else {return [:]}
        
        guard let iv = KeychainWrapper.standard.string(forKey: "\(fileName)-Disk-IV") else {return [:]}
        
        let decrypted = encrypted.decryptedAES(withKey: key, iv: iv)
        
        guard let dic = try? JSONSerialization.jsonObject(with: decrypted, options: []) as? JSONObject else {return [:]}
        
        allMapsInMemory[fileName] = dic
        
        if dic != nil { print("Successfully decrypted map for type: \(type)") }
        
        return dic ?? [:]
      }
      
      // Create an empty map on disk.
      else {
        
        let dic: JSONObject = [:]
        
        let data = try! JSONSerialization.data(withJSONObject: dic, options: [])
        
        if FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil) {
          
          print("Successfully created empty map for type: \(type) on disk")
        }
        
        allMapsInMemory[fileName] = dic
        
        return dic
      }
    }
    
//    else if let dic = ERModelCache.userDefaultsStore.value(forKey: key) as? JSONObject {
//
//      //if ERModelCache.logsCaching { printPretty("Loaded \(T.self) map from disk.") }
//
//      allMapsInMemory[key] = dic
//
//      return dic
//    }
//
//    else {
//
//      let dic: JSONObject = [:]
//
//      ERModelCache.userDefaultsStore.setValue(dic, forKey: key)
//
//      allMapsInMemory[key] = dic
//
//      //if ERModelCache.logsCaching { printPretty("Initialized \(T.self) map in disk.") }
//
//      return dic
//    }
  }
  
  private func save<T: ERModelType>(map: JSONObject, type: T.Type) {
    
    let fileName = fileNameForType(type: type)

    allMapsInMemory[fileName] = map
    
    let encryptionKey: String
    
    let iv: String
    
    if let existingKey = KeychainWrapper.standard.string(forKey: "\(fileName)-Disk-Key") { encryptionKey = existingKey }
    
    else { encryptionKey = String.random(length: 32); KeychainWrapper.standard.set(encryptionKey, forKey: "\(fileName)-Disk-Key") }
    
    if let existingIV = KeychainWrapper.standard.string(forKey: "\(fileName)-Disk-IV") { iv = existingIV }
    
    else { iv = String.random(length: 16); KeychainWrapper.standard.set(iv, forKey: "\(fileName)-Disk-IV") }
    
    guard let rawData = try? JSONSerialization.data(withJSONObject: map, options: []) else {return}
  
    let encrypted = rawData.encrptedAES(withKey: encryptionKey, iv: iv)
    
    let url = diskURLForType(type: type)

    do {
      
      try encrypted.write(to: url, options: .completeFileProtection)
      
      if ERModelCache.logsCaching { printPretty("Saved all models in memory to disk") }
      
    }
    
    catch { print("An error ocurred writing the encrypted data to \(url) - \(error)") }
  }
  
  //**************************************************//
  
  // MARK: Data Retreival
  
  public func allModels<T: ERModelType>() -> [T] {
    
    let map = mapForType(type: T.self)
    
    guard let jsons = Array(map.values) as? [JSONObject] else {return []}
    
    var list: [T] = []
    
    for json in jsons {
      
      guard let model: T = json.unboxedObject() else {continue}
      
      list.append(model)
    }
    
    if ERModelCache.logsCaching { printPretty("Retreived all \(T.self) models from cache") }
    
    return list
  }
  
  public func allIdentifiersForType<T: ERModelType>(type: T.Type) -> [String] {
    
    let map = mapForType(type: type)
    
    return Array<String>(map.keys)
  }
  
  public func getModelWith<T: ERModelType>(id: String) -> T? {
    
    let map = mapForType(type: T.self)
    
    guard let modelJSON = map[id] as? JSONObject else {
      
      if ERModelCache.logsCaching { printPretty("Model of type \(T.self) with id \(id) doesn't exist in cache.") }
      
      return nil
    }
    
    if ERModelCache.logsCaching { printPretty("Retreived model of type \(T.self) with id \(id) from cache.") }
    
    return modelJSON.unboxedObject()
  }
  
  public func getModelsWith<T: ERModelType>(ids: [String]) -> [T] {
    
    let map = mapForType(type: T.self)
    
    var array: [T] = []
    
    for id in ids {
      
      guard let modelJSON = map[id] as? JSONObject else { continue }
      
      guard let model: T = modelJSON.unboxedObject() else {continue}
      
      array.append(model)
    }
    
    return array
  }
  
  //**************************************************//
  
  // MARK: Data Addition
  
  public func swap<T: ERModelType>(modelJSON: JSONObject, type: T.Type) {
    
    let keys = Array<String>(modelJSON.keys)
    
    var map = mapForType(type: type)
    
    for key in keys {
      
      guard let itemJSON = modelJSON[key] as? JSONObject else {continue}
      
      guard let _: T = itemJSON.unboxedObject() else {continue}
      
      let dic = NSDictionary(dictionary: itemJSON)
      
      map[key] = dic
    }
    
    save(map: map, type: type)
    
    if ERModelCache.logsCaching { printPretty("Updated \(keys.count) \(T.self) models in cache") }
  }
  
  public func add<T: ERModelType>(model: T) {
    
    guard let modelJSON = model.JSON else {return}
    
    var map = mapForType(type: T.self)
    
    let dic = NSDictionary(dictionary: modelJSON)
    
    map[model.id] = dic
    
    save(map: map, type: T.self)
    
    if ERModelCache.logsCaching { printPretty("Updated \(T.self) model in cache") }
  }
  
  public func add<T: ERModelType>(models: [T]) {
    
    var map = mapForType(type: T.self)
    
    for model in models {
      
      guard let modelJSON = model.JSON else {continue}
      
      let dic = NSDictionary(dictionary: modelJSON)
      
      map[model.id] = dic
    }
    
    save(map: map, type: T.self)
    
    if ERModelCache.logsCaching { printPretty("Updated \(models.count) \(T.self) models in cache") }
  }
  
  //**************************************************//
  
  // MARK: Data Checking
  
  public func contains<T: ERModelType>(model: T) -> Bool { return containsModel(withId: model.id, ofType: T.self) }
  
  public func containsModel<T: ERModelType>(withId id: String, ofType type: T.Type) -> Bool { return mapForType(type: type)[id] != nil }
  
  //**************************************************//
  
  // MARK: Data Removal
  
  public func remove<T: ERModelType>(model: T) {
    
    var map = mapForType(type: T.self)
    
    map.removeValue(forKey: model.id)
    
    save(map: map, type: T.self)
    
    if ERModelCache.logsCaching { printPretty("Removed \(T.self) model from cache") }
  }
  
  public func remove<T: ERModelType>(models: [T]) {
    
    var map = mapForType(type: T.self)
    
    for model in models { map.removeValue(forKey: model.id) }
    
    save(map: map, type: T.self)
    
    if ERModelCache.logsCaching { printPretty("Remove \(models.count) \(T.self) models from cache") }
  }
  
  //**************************************************//
  
  // MARK: Data Clearing
  
  public func clearDataForType<T: ERModelType>(type: T.Type) {
    
    var map = mapForType(type: type)
    
    map.removeAll()
    
    save(map: map, type: type)
    
    if ERModelCache.logsCaching { printPretty("Successfully cleared all \(type) models in cache") }
  }
  
  public func clearAllData() {
    
    allMapsInMemory.removeAll()
  
    guard FileManager.default.fileExists(atPath: diskDirectoryURL.path) else {return}
    
    do {
      
      try FileManager.default.removeItem(at: diskDirectoryURL)
      
      if ERModelCache.logsCaching { printPretty("Successfully cleared all data in cache") }
      
    }
    
    catch { print("An error ocurred trying to clear all data from the disk: \(error)") }
  }
  
  //**************************************************//
}

extension ERModelCache {
  
  fileprivate var docomuentsDirectoryURL: URL { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] }
  
  fileprivate var diskDirectoryURL: URL { return docomuentsDirectoryURL.appendingPathComponent("ERModelCache") }
}

extension ERModelType {
    
  public static func allModelsInCache() -> [Self] { return ERModelCache.shared.allModels() }
  
  public static func getModelInCacheWith(id: String) -> Self? { return ERModelCache.shared.getModelWith(id: id) }
  
  public static func getModelsInCacheWith(ids: [String]) -> [Self] { return ERModelCache.shared.getModelsWith(ids: ids) }
}
