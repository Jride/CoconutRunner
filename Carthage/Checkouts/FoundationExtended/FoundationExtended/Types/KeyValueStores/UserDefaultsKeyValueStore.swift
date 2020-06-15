//
//  UserDefaultsKeyValueStore.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public class UserDefaultsKeyValueStore: KeyValueStore {
    
    private let userDefaults: UserDefaults
    
    public init() {
        self.userDefaults = UserDefaults.standard
    }
    
    public init(suiteName: String) {
        self.userDefaults = UserDefaults(suiteName: suiteName)!
    }
    
    public func set(value: Any, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func value(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }
    
    public func set(bool: Bool, forKey key: String) {
        userDefaults.set(bool, forKey: key)
    }
    
    public func bool(forKey key: String) -> Bool? {
        return userDefaults.object(forKey: key) as? Bool
    }
    
    public func set(string: String, forKey key: String) {
        userDefaults.setValue(string, forKey: key)
    }
    
    public func string(forKey key: String) -> String? {
        return userDefaults.object(forKey: key) as? String
    }
    
    public func set(int: Int, forKey key: String) {
        userDefaults.setValue(int, forKey: key)
    }
    
    public func int(forKey key: String) -> Int? {
        return userDefaults.object(forKey: key) as? Int
    }
    
    public func set(date: Date, forKey key: String) {
        userDefaults.setValue(date, forKey: key)
    }
    
    public func date(forKey key: String) -> Date? {
        return userDefaults.object(forKey: key) as? Date
    }
    
    public func set(dict: [String : Any], forKey key: String) {
        userDefaults.setValue(dict, forKey: key)
    }
    
    public func dict(forKey key: String) -> [String : Any]? {
        return userDefaults.object(forKey: key) as? [String : Any]
    }
}

