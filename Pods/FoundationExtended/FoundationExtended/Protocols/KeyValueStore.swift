//
//  KeyValueStore.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

/// A key-value store
public protocol KeyValueStore {
    
    func set(value: Any, forKey key: String)
    func value(forKey key: String) -> Any?
    
    func set(bool: Bool, forKey key: String)
    func bool(forKey key: String) -> Bool?
    
    func set(string: String, forKey key: String)
    func string(forKey key: String) -> String?
    
    func set(int: Int, forKey key: String)
    func int(forKey key: String) -> Int?
    
    func set(date: Date, forKey key: String)
    func date(forKey key: String) -> Date?
    
    func set(dict: [String: Any], forKey key: String)
    func dict(forKey key: String) -> [String: Any]?
}

/// A key-value store that writes changes to some external store when `synchronize` is called and can
/// delete all data when `flush` is called. After changes have been made, it is the user's
/// responsibility to call `synchronize` to persist them.
public protocol SynchronizableKeyValueStore: KeyValueStore {
    func synchronize()
    func flush()
}
