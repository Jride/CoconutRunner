//
//  Dictionary+ThrowingAccessor.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    enum DictionaryAccessError: Error {
        case noValue
        case incorrectType
    }
    
    func string(forKey key: Key) throws -> String {
        
        do {
            let string: String = try getValue(forKey: key)
            return string
        } catch let error {
            throw error
        }
    }
    
    func bool(forKey key: Key) throws -> Bool {
        
        do {
            let bool: Bool = try getValue(forKey: key)
            return bool
        } catch let error {
            throw error
        }
    }
    
    func int(forKey key: Key) throws -> Int {
        
        do {
            let int: Int = try getValue(forKey: key)
            return int
        } catch let error {
            throw error
        }
    }
    
    func date(forKey key: Key) throws -> Date {
        
        do {
            let date: Date = try getValue(forKey: key)
            return date
        } catch let error {
            throw error
        }
    }
    
    func jsonDictionary(forKey key: Key) throws -> [String: Any] {
        
        do {
            let dictionary: [String: Any] = try getValue(forKey: key)
            return dictionary
        } catch let error {
            throw error
        }
    }
    
    func arrayOfStrings(forKey key: Key) throws -> [String] {
        
        do {
            let strings: [String] = try getValue(forKey: key)
            return strings
        } catch let error {
            throw error
        }
    }
    
    private func getValue<T>(forKey key: Key) throws -> T {
        
        guard let value = self[key] else {
            throw DictionaryAccessError.noValue
        }
        
        guard let type = value as? T else {
            throw DictionaryAccessError.incorrectType
        }
        
        return type
    }
}
