//
//  Dictionary+AccessorWithDefaults.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 26/06/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    func string(forKey key: Key, default: String) -> String {
        
        guard let string: String = getValue(forKey: key) else {
            return `default`
        }
        
        return string
    }
    
    func bool(forKey key: Key, default: Bool) -> Bool {
        
        guard let bool: Bool = getValue(forKey: key) else {
            return `default`
        }
        
        return bool
    }
    
    func int(forKey key: Key, default: Int) -> Int {
        
        guard let int: Int = getValue(forKey: key) else {
            return `default`
        }
        
        return int
    }
    
    func jsonDictionary(forKey key: Key, default: [String: Any]) -> [String: Any] {
        
        guard let dictionary: [String: Any] = getValue(forKey: key) else {
            return `default`
        }
        
        return dictionary
    }
    
    func arrayOfStrings(forKey key: Key, default: [String]) -> [String] {
        
        guard let strings: [String] = getValue(forKey: key) else {
            return `default`
        }
        
        return strings
    }
    
    private func getValue<T>(forKey key: Key) -> T? {
        
        guard let value = self[key], let type = value as? T  else {
            return nil
        }
        
        return type
    }
}
