//
//  PlistStore.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 27/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public class PlistStore: SynchronizableKeyValueStore {
    
    private let url: URL
    private let fileManager = FileManager.default
    private var dictionary: [String: Any]
    
    public init(url: URL) {
        
        self.url = url
        
        do {
            let data = try Data(contentsOf: url)
            let plist = try PropertyListSerialization.propertyList(from: data,
                                                                   options: [],
                                                                   format: nil) as? [String: Any]
            dictionary = try plist.unwrapThrowing()
        } catch {
            dictionary = [String: Any]()
        }
    }
    
    public func set(value: Any, forKey key: String) {
        dictionary[key] = value
    }
    
    public func value(forKey key: String) -> Any? {
        return dictionary[key]
    }
    
    public func set(bool: Bool, forKey key: String) {
        dictionary[key] = bool
    }
    
    public func bool(forKey key: String) -> Bool? {
        return dictionary[key] as? Bool
    }
    
    public func set(string: String, forKey key: String) {
        dictionary[key] = string
    }
    
    public func string(forKey key: String) -> String? {
        return dictionary[key] as? String
    }
    
    public func set(int: Int, forKey key: String) {
        dictionary[key] = int
    }
    
    public func int(forKey key: String) -> Int? {
        return dictionary[key] as? Int
    }
    
    public func set(date: Date, forKey key: String) {
        dictionary[key] = date
    }
    
    public func date(forKey key: String) -> Date? {
        return dictionary[key] as? Date
    }
    
    public func set(dict: [String : Any], forKey key: String) {
        dictionary[key] = dict
    }
    
    public func dict(forKey key: String) -> [String: Any]? {
        return dictionary[key] as? [String: Any]
    }
    
    public func synchronize() {
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            try data.write(to: url)
        } catch let error {
            print("Error writing plist: \(error)")
        }
    }
    
    public func flush() {
        
        dictionary = [String: Any]()
        
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            print("Error removing plist: \(error)")
        }
    }
}
