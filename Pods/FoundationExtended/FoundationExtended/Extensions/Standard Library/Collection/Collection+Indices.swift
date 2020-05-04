//
//  Collection+Indices.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Indexes
extension Collection {
    
    public var lastIndex: Int? {
        
        if count - 1 >= 0 {
            return Int(count) - 1
        } else {
            return nil
        }
    }
    
    public func indices(where isIncluded: (Element) -> Bool) -> [Int] {
        var tmpArray: [Int] = []
        
        for (i, element) in self.enumerated() {
            if isIncluded(element) {
                tmpArray.append(i)
            }
        }
        
        return tmpArray
    }
}
