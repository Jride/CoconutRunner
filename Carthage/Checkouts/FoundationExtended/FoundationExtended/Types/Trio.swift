//
//  Trio.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 05/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

/// Struct containing three things of type T
public struct Trio<Element>: Collection {
    
    public var first: Element {
        get { return array[0] }
        set { array[0] = newValue }
    }
    
    public var second: Element {
        get { return array[1] }
        set { array[1] = newValue }
    }
    
    public var third: Element {
        get { return array[2] }
        set { array[2] = newValue }
    }
    
    public var startIndex: Int {
        return array.startIndex
    }
    
    public var endIndex: Int {
        return array.endIndex
    }
    
    // Even though it's a bit of a messier implementation, trio uses Array internally
    // so that we get COW for free, and to make it easy to piggy back off array
    // functions (eg. map)
    private var array: [Element]
    
    public init(_ first: Element, _ second: Element, _ third: Element) {
        self.array = [first, second, third]
    }
    
    public func map<T>(_ transform: (Element) throws -> T) rethrows -> Trio<T> {
        
        let mapped = try array.map(transform)
        return Trio<T>(mapped[0], mapped[1], mapped[2])
    }
    
    public subscript (position: Int) -> Element {
        precondition(array.indices.contains(position), "out of bounds")
        return array[position]
    }
    
    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }
}

// MARK: - Equatable

extension Trio: Equatable where Element: Equatable {
    public static func == (lhs: Trio, rhs: Trio) -> Bool {
        return lhs.array == rhs.array
    }
}
