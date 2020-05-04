//
//  DictionaryRepresentable.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Protocols

public protocol DictionaryDecodable {
    init?(dictionary: [String: Any])
}

public protocol DictionaryEncodable {
    var dictionaryRepresentation: [String: Any] {get}
}

public protocol DictionaryRepresentable: DictionaryDecodable, DictionaryEncodable {}

// MARK: - Codable conformance

public extension DictionaryDecodable where Self: Codable {
    
    init?(dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        
        guard let object = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        
        self = object
    }
}

public extension DictionaryEncodable where Self: Codable {
    
    var dictionaryRepresentation: [String: Any] {
        let data = (try? JSONEncoder().encode(self)).require("Object should be encodable")
        return ((try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any])
            .require("Object should create valid dictionary")
    }
}
