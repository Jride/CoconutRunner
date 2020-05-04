//
//  Array+Chunking.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Chunk

extension Array {
    
    public func chunk(size: Int) -> [[Element]] {
        
        return stride(from: 0, to: self.count, by: size).map {
            let chunkStart = $0
            let chunkEnd = Swift.min($0 + size, self.count)
            return self[chunkStart..<chunkEnd].toArray()
        }
    }
    
    public func split<T: Equatable>(atChangeTo key: (Element) -> T) -> [[Element]] {
        
        var groups = [[Element]]()
        
        func addGroup(_ groupToAdd: [Element]) {
            if groupToAdd.isEmpty == false {
                groups.append(groupToAdd)
            }
        }
        
        var lastKey: T?
        var currentGroup = [Element]()
        
        for item in self {
            let itemKey = key(item)
            if itemKey == lastKey {
                currentGroup.append(item)
            } else {
                addGroup(currentGroup)
                currentGroup.removeAll()
                currentGroup.append(item)
            }
            lastKey = itemKey
        }
        
        addGroup(currentGroup)
        return groups
    }
    
    public func split(prefix prefixSize: Int) -> [[Element]] {
        guard prefixSize >= 0 else {
            fatalError("Provided a negative number for Array split prefix.")
        }
        
        guard prefixSize > 0 else {
            return [self]
        }
        
        let prefix = self.prefix(prefixSize).toArray()
        
        guard prefix.count > 0 else {
            return []
        }
        
        guard self.count > prefixSize else {
            return [prefix]
        }
        
        let suffix = self.suffix(from: prefixSize).toArray()
        
        return [prefix, suffix]
    }
}
