//
//  WeakArray.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

private struct WeakItemWrapper {
    
    private weak var p_object: AnyObject?
    
    init(object: AnyObject) {
        p_object = object
    }
    
    var object: AnyObject? {
        return p_object
    }
}

public struct WeakArray<T>: RandomAccessCollection, Sequence {
    
    // MARK: - Manage wrapped items
    
    private var wrappedItems: [WeakItemWrapper]
    
    public mutating func removeDeallocatedItems() {
        wrappedItems = wrappedItems.filter { $0.object != nil }
    }
    
    public var unwrappedItems: [T] {
        return wrappedItems.compactMap { $0.object as? T }
    }
    
    // MARK: - Init
    
    public init() {
        wrappedItems = [WeakItemWrapper]()
    }
    
    public var count: Int {
        return unwrappedItems.count
    }
    
    public init(objects: [T]) {
        guard let anyObjects = objects as [AnyObject]? else {
            fatalAnyObjectError()
        }
        wrappedItems = anyObjects.map(WeakItemWrapper.init)
    }
    
    public init(objects: T...) {
        guard let anyObjects = objects as [AnyObject]? else {
            fatalAnyObjectError()
        }
        wrappedItems = anyObjects.map(WeakItemWrapper.init)
    }
    
    // MARK: - Add / Remove
    
    public mutating func append(_ newElement: T) {
        removeDeallocatedItems()
        
        guard let anyObject = newElement as AnyObject? else {
            fatalAnyObjectError()
        }
        
        wrappedItems.append( WeakItemWrapper(object: anyObject) )
    }
    
    public mutating func removeAll() {
        wrappedItems.removeAll()
    }
        
    public mutating func removeAll(where shouldRemove: (T) -> Bool) {
        
        wrappedItems = wrappedItems
            .compactMap { $0.object }
            .filter { !shouldRemove($0 as! T) }
            .map(WeakItemWrapper.init)
    }
    
    public mutating func remove(object: T) {
        self.removeAll(where: { ($0 as AnyObject) === (object as AnyObject) })
    }
    
    // MARK: - Contains
    
    public func contains(object: T) -> Bool {
        return contains { ($0 as AnyObject) === (object as AnyObject) }
    }
    
    // MARK: - For Each
    
    public func forEach(_ body: @escaping (Element) throws -> Void) rethrows {
        try unwrappedItems.forEach(body)
    }
    
    // For-in
    
    public func makeIterator() -> IndexingIterator<[T]> {
        return unwrappedItems.makeIterator()
    }
    
    // MARK: - RandomAccessCollection conformance
    
    public typealias Index = Int
    public typealias Element = T
    
    public var startIndex: Index { return unwrappedItems.startIndex }
    public var endIndex: Index { return unwrappedItems.endIndex }
    
    public subscript(index: Index) -> Element {
        get { return unwrappedItems[index] }
    }
    
    public func index(after i: Index) -> Index {
        return unwrappedItems.index(after: i)
    }
    
    public func index(before i: WeakArray<T>.Index) -> WeakArray<T>.Index {
        return unwrappedItems.index(before: i)
    }
}

extension WeakArray where T: AnyObject {
    public mutating func remove(object: T) {
        self.removeAll(where: { $0 === object })
    }
}

private func fatalAnyObjectError() -> Never {
    fatalError("WeakArray can only work with types conforming to AnyObject")
}
