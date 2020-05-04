//
//  Dictionary+DictionaryDecodable.swift
//  FoundationExtended
//
//  Created by Stancho Stanchev on 20/03/2020.
//  Copyright © 2020 ITV. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {
    
    func array<T: DictionaryDecodable>(of elementType: T.Type, key: Key) -> [T] {
        let dictionaries = self[key] as? [[String: Any]] ?? []
        return dictionaries.compactMap(T.init)
    }
}

public extension Dictionary {
    
    func decode<T: DictionaryDecodable>(_ decode: T.Type, key: Key) -> T? {
        if let dict = self[key] as? [String: Any] {
            return T(dictionary: dict)
        } else {
            return nil
        }
    }
    
    func decode<T: DictionaryDecodable>(throwing: T.Type, key: Key) throws -> T {
        let dict = try (self[key] as? [String: Any]).unwrapThrowing()
        return try T(dictionary: dict).unwrapThrowing()
    }
}
