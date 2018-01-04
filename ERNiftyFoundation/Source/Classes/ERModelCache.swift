//
//  MTLCache.swift
//  MetalPay
//
//  Created by Ephraim Russo on 12/28/17.
//  Copyright © 2017 Metallicus Inc. All rights reserved.
//

import Foundation

public class ERModelCache {
  
  private static let defaultsKey = "model_cache"
  
  public static var logsCaching = false
  
  public static var userDefaultsStore: UserDefaults = .standard
  
  public static let shared: ERModelCache = {
    
    let cache = ERModelCache()
    
    return cache
  }()
  
  private func defaultsKeyForType<T: ERModelType>(type: T.Type) -> String { return "\(T.self)" }
  
  private func mapForType<T: ERModelType>(type: T.Type) -> JSONObject {
    
    let key = defaultsKeyForType(type: type)
    
    if let dic =  ERModelCache.userDefaultsStore.object(forKey: key) as? JSONObject {
      
      return dic
    }
      
    else {
      
      let dic: JSONObject = [:]
      
      ERModelCache.userDefaultsStore.set(dic, forKey: key)
      
      return dic
    }
  }
  
  private func save<T: ERModelType>(map: JSONObject, type: T.Type) {
    
    let key = defaultsKeyForType(type: type)
    
    ERModelCache.userDefaultsStore.set(map, forKey: key)
  }
  
  public func allModels<T: ERModelType>() -> [T] {
    
    let map = mapForType(type: T.self)
    
    guard let jsons = Array(map.values) as? [JSONObject] else {return []}
    
    var list: [T] = []
    
    for json in jsons {
      
      guard let model: T = json.unboxedObject() else {continue}
      
      list.append(model)
    }
    
    return list
  }
  
  public func allIdentifiersForType<T: ERModelType>(type: T.Type) -> [String] {
    
    let map = mapForType(type: type)
    
    return Array<String>(map.keys)
  }
  
  public func getModelWith<T: ERModelType>(id: String) -> T? {
    
    let map = mapForType(type: T.self)
    
    guard let modelJSON = map[id] as? JSONObject else {
      
      if ERModelCache.logsCaching {
        print("*****************************************")
        print("")
        print("Model of type \(T.self) with id \(id) doesn't exist in cache.")
        print("")
      }
      
      return nil
    }
    
    if ERModelCache.logsCaching {
      
      print("*****************************************")
      print("")
      print("Retreived model of type \(T.self) with id \(id) from cache.")
      print("")
    }
    
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
  }
  
  public func add<T: ERModelType>(model: T) {
    
    guard let modelJSON = model.JSON else {return}
    
    var map = mapForType(type: T.self)
    
    let dic = NSDictionary(dictionary: modelJSON)
    
    map[model.id] = dic
    
    save(map: map, type: T.self)
  }
  
  public func add<T: ERModelType>(models: [T]) {
    
    var map = mapForType(type: T.self)
    
    for model in models {
      
      guard let modelJSON = model.JSON else {continue}
      
      let dic = NSDictionary(dictionary: modelJSON)
      
      map[model.id] = dic
    }
    
    save(map: map, type: T.self)
  }
  
  public func contains<T: ERModelType>(model: T) -> Bool { return containsModel(withId: model.id, ofType: T.self) }
  
  public func containsModel<T: ERModelType>(withId id: String, ofType type: T.Type) -> Bool { return mapForType(type: type)[id] != nil }
  
  public func remove<T: ERModelType>(model: T) {
    
    var map = mapForType(type: T.self)
    
    map.removeValue(forKey: model.id)
    
    save(map: map, type: T.self)
  }
  
  public func clearDataForType<T: ERModelType>(type: T.Type) {
    
    var map = mapForType(type: type)
    
    map.removeAll()
    
    save(map: map, type: type)
  }
}
