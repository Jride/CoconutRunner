//
//  Array+Extract.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func extract(isIncluded: (Element) -> Bool) -> [Element] {
        
        let extractedItems = self.filter { isIncluded($0) }
        self = self.filter { isIncluded($0) == false }
        return extractedItems
    }
    
    public mutating func extractFirst(isItem: (Element) -> Bool) -> Element? {
        
        var extractedItem: Element?
        var extractedIndex: Int?
        
        for (index, item) in self.enumerated() {
            if isItem(item) {
                extractedItem = item
                extractedIndex = index
                break
            }
        }
        
        if let indexToRemove = extractedIndex {
            self.remove(at: indexToRemove)
        }
        
        return extractedItem
    }
    
    public mutating func extractFirst(_ number: Int, isIncluded: (Element) -> Bool) -> [Element] {
        
        var extractedItems = [Element]()
        var indexesToRemove = [Int]()
        var extractedCount = 0
        
        for (index, item) in self.enumerated() {
            
            guard isIncluded(item) else {
                continue
            }
            
            extractedItems.append(item)
            indexesToRemove.append(index)
            extractedCount += 1
            if extractedCount == number {
                break
            }
        }
        
        // Remove the indexes in reverse order so that we don't get any invalid indexes
        indexesToRemove.reversed().forEach {
            self.remove(at: $0)
        }
        
        return extractedItems
    }
    
    public mutating func extractFirstCompacted<T>(_ number: Int, transform: (Element) -> T?) -> [T] {
        
        var extractedItems = [T]()
        var indexesToRemove = [Int]()
        var extractedCount = 0
        
        for (index, item) in self.enumerated() {
            
            guard let transformedItem = transform(item) else {
                continue
            }
            
            extractedItems.append(transformedItem)
            indexesToRemove.append(index)
            extractedCount += 1
            if extractedCount == number {
                break
            }
        }
        
        // Remove the indexes in reverse order so that we don't get any invalid indexes
        indexesToRemove.reversed().forEach {
            self.remove(at: $0)
        }
        
        return extractedItems
    }
    
    public mutating func extractFirstCompacted<T>(transform: (Element) -> T?) -> T? {
        
        var extractedItem: T?
        var extractedIndex: Int?
        
        for (index, item) in self.enumerated() {
            if let transformedItem = transform(item) {
                extractedItem = transformedItem
                extractedIndex = index
                break
            }
        }
        
        if let indexToRemove = extractedIndex {
            remove(at: indexToRemove)
        }
        
        return extractedItem
    }
}
