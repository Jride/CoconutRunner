//
//  WeakSet.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 31/10/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public struct WeakObjectSet<T>: Sequence {
    
    private var weakArray = WeakArray<T>()
    
    public var count: Int {
        return weakArray.count
    }
    
    public init() {}
    
    public func makeIterator() -> IndexingIterator<[T]> {
        return weakArray.makeIterator()
    }
    
    public mutating func insert(object: T) {
        if weakArray.contains(object: object) == false {
            weakArray.append(object)
        }
    }
    
    public mutating func remove(object: T) {
        weakArray.remove(object: object)
    }
    
    public mutating func removeAll() {
        weakArray.removeAll()
    }
}
