//
//  UserPreferences.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

/// UserPreferences is a wrapper for UserDefaults, storing values in an inner `UserPreferences` dictionary
public class UserPreferences: KeyValueStore {
    
    private let userDefaults = UserDefaults.standard
    private let dictionaryKey = "UserPreferences"
    
    private var preferences: [String: Any] {
        get {
            return userDefaults.object(forKey: dictionaryKey) as? [String: Any] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: dictionaryKey)
        }
    }
    
    public init() {}
    
    public func set(value: Any, forKey key: String) {
        preferences[key] = value
    }
    
    public func value(forKey key: String) -> Any? {
        return preferences[key]
    }
    
    public func set(bool: Bool, forKey key: String) {
        preferences[key] = bool
    }
    
    public func bool(forKey key: String) -> Bool? {
        return preferences[key] as? Bool
    }
    
    public func set(string: String, forKey key: String) {
        preferences[key] = string
    }
    
    public func string(forKey key: String) -> String? {
        return preferences[key] as? String
    }
    
    public func set(int: Int, forKey key: String) {
        preferences[key] = int
    }
    
    public func int(forKey key: String) -> Int? {
        return preferences[key] as? Int
    }
    
    public func set(date: Date, forKey key: String) {
        preferences[key] = date
    }
    
    public func date(forKey key: String) -> Date? {
        return preferences[key] as? Date
    }
    
    public func set(dict: [String : Any], forKey key: String) {
        preferences[key] = dict
    }
    
    public func dict(forKey key: String) -> [String : Any]? {
        return preferences[key] as? [String : Any]
    }
    
    public func clear() {
        preferences = [:]
    }
}
