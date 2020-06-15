//
//  Array+Insertion.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func prepend(_ item: Element) {
        insert(item, at: 0)
    }
    
    public mutating func prepend<C>(contentsOf newElements: C) where C: Collection, Element == C.Element {
        insert(contentsOf: newElements, at: 0)
    }
    
    public func prepending(_ item: Element) -> [Element] {
        var newArray = self
        newArray.insert(item, at: 0)
        return newArray
    }
    
    public func prepending<C>(contentsOf newElements: C) -> [Element] where C: Collection, Element == C.Element {
        var newArray = self
        newArray.insert(contentsOf: newElements, at: 0)
        return newArray
    }
    
    public func appending(_ item: Element) -> [Element] {
        var newArray = self
        newArray.append(item)
        return newArray
    }
    
    public mutating func insert(_ item: Element, safelyAt index: Int) {
        if indices.contains(index) || index == endIndex {
            insert(item, at: index)
        }
    }
    
    public mutating func insertOrAppend(_ item: Element, at index: Int) {
        if indices.contains(index) {
            insert(item, at: index)
        } else {
            insert(item, at: endIndex)
        }
    }
    
    public subscript(safe index: Int) -> Element? {
        get {
            return self[maybe: index]
        }
        set {
            if let value = newValue {
                insert(value, safelyAt: index)
            }
        }
    }
}
