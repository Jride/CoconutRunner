//
//  Array+Sorting.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Sorted Ascending / Descending

extension Array where Element: Comparable {
    
    public func sortedAscending() -> [Element] {
        return sorted { $0 < $1 }
    }
    
    public func sortedDescending() -> [Element] {
        return sorted { $0 > $1 }
    }
    
    public mutating func sortAscending() {
        sort { $0 < $1 }
    }
    
    public mutating func sortDescending() {
        sort { $0 > $1 }
    }
}

// MARK: - Insert Sort

public extension Array {
    
     /// Walks the array, inserting the new element at the appropriate position assuming
     /// that the array is sorted ascending by the passed in transform
     ///
     /// - Parameters:
     ///   - item: The item to insert
     ///   - key: Closure to transform each item to a comparable key
     /// - Returns: The index that the item was inserted at
     mutating func insert<T: Comparable>(_ item: Element, sortedAscendingBy key: (Element) -> T) -> Int {
        
        let itemKey = key(item)
        
        var insertionIndex: Int?
        
        for (index, existingItem) in self.enumerated() {
            if itemKey < key(existingItem) {
                insertionIndex = index
                break
            }
        }

        if let index = insertionIndex, let lastIndex = self.lastIndex, index <= lastIndex {
            self.insert(item, at: index)
            return index
        } else {
            self.append(item)
            return self.lastIndex!
        }
    }
    
    /// Walks the array, inserting the new element at the appropriate position assuming
    /// that the array is sorted ascending by the passed in transform
    ///
    /// - Parameters:
    ///   - item: The item to insert
    ///   - key: Closure to transform each item to a comparable key
    /// - Returns: The index that the item was inserted at
    mutating func insert<T: Comparable>(_ item: Element, sortedDescendingBy key: (Element) -> T) -> Int {
        
        let itemKey = key(item)
        
        var insertionIndex: Int?
        
        for (index, existingItem) in self.enumerated() {
            if itemKey > key(existingItem) {
                insertionIndex = index
                break
            }
        }
        
        if let index = insertionIndex, let lastIndex = self.lastIndex, index <= lastIndex {
            self.insert(item, at: index)
            return index
        } else {
            self.append(item)
            return self.lastIndex!
        }
    }
}

// MARK: - Sorted Ascending / Descending by

extension Array {
    
    public func sortedAscendingBy<T: Comparable>(_ key: (Element) -> T) -> [Element] {
        return sorted { key($0) < key($1) }
    }
    
    public func sortedDescendingBy<T: Comparable>(_ key: (Element) -> T) -> [Element] {
        return sorted { key($0) > key($1) }
    }
    
    public mutating func sortAscendingBy<T: Comparable>(_ key: (Element) -> T) {
        sort { key($0) < key($1) }
    }
    
    public mutating func sortDescendingBy<T: Comparable>(_ key: (Element) -> T) {
        sort { key($0) > key($1) }
    }
}

// MARK: - Bring to front / Send to back

extension Array {
    
    public mutating func bringToFront(_ matches: (Element) -> Bool) {
        
        var indexesToMove = [Int]()
        var itemsToMove = [Element]()
        
        // Find the items that we need to move
        for (index, item) in self.enumerated() {
            if matches(item) {
                indexesToMove.append(index)
                itemsToMove.append(item)
            }
        }
        
        // We remove the last items first, so that the indexes are always in bounds
        for index in indexesToMove.reversed() {
            remove(at: index)
        }
        
        // Insert the items at the front
        // in the reverse order that we found them
        // so that they maintain their original order
        itemsToMove.reversed().forEach {
            insert($0, at: 0)
        }
    }
    
    public mutating func sendToBack(_ matches: (Element) -> Bool) {
        
        var indexesToMove = [Int]()
        var itemsToMove = [Element]()
        
        // Find the items that we need to move
        for (index, item) in self.enumerated() {
            if matches(item) {
                indexesToMove.append(index)
                itemsToMove.append(item)
            }
        }
        
        // We remove the last items first, so that the indexes are always in bounds
        for index in indexesToMove.reversed() {
            remove(at: index)
        }
        
        // Insert the items at the back
        itemsToMove.forEach {
            append($0)
        }
    }
}
