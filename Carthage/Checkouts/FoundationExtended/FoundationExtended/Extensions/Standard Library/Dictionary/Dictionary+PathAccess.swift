//
//  Dictionary+PathAccess.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 06/11/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

struct PathAccessError: Error {}

public extension Dictionary where Key == String {
    
    func get<T>(path: String, as: T.Type) -> T? {
        return JsonPathAccessor.object(atPath: path, in: self) as? T
    }
    
    func getThrowing<T>(path: String, as: T.Type) throws -> T {
                
        if let obj = JsonPathAccessor.object(atPath: path, in: self) as? T {
            return obj
        } else {
            throw PathAccessError()
        }
    }
}

private class JsonPathAccessor {
    
    static func object(atPath path: String, in dictionary: [String: Any]) -> Any? {
        
        let components = path.split(separator: "/").map { $0.toString() }
        return findObject(pathComponents: components, in: dictionary)
    }
    
    static func findObject(pathComponents: [String],
                           in dictionary: Dictionary<String, Any>) -> Any? {
        
        guard let key = pathComponents.first else {
            return nil
        }
        
        let remainingComponents = pathComponents.dropFirst()
        if remainingComponents.isEmpty {
            return dictionary[key]
        } else {
            if let innerDict = dictionary[key] as? [String: Any] {
                return findObject(pathComponents: remainingComponents.toArray(), in: innerDict)
            } else {
                return nil
            }
        }
    }
}
