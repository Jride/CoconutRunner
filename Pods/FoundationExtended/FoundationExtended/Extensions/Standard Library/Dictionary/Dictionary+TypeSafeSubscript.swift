//
//  Dictionary+TypeSafeSubscript.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String {
    
    subscript(string key: String) -> String? {
        return self[key] as? String
    }
    
    subscript(bool key: String) -> Bool? {
        return self[key] as? Bool
    }
    
    // MARK: - Numeric
    
    subscript(int key: String) -> Int? {
        return self[key] as? Int
    }
    
    subscript(float key: String) -> Float? {
        return self[key] as? Float
    }
    
    subscript(double key: String) -> Double? {
        return self[key] as? Double
    }
    
    // MARK: - Dictionary
    
    subscript(jsonDictionary key: String) -> [String: Any]? {
        return self[key] as? [String: Any]
    }
    
    subscript(jsonDictOrEmpty key: String) -> [String: Any] {
        guard let value = self[key] as? [String: Any] else {
            return [:]
        }
        
        return value
    }
}
