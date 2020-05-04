//
//  Collection+Accessors.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Throwing accessor

public enum CollectionAccessError: Error {
    case outOfBounds
}

extension Collection where Index == Int {
    
    public func at(throwing index: Index) throws -> Element {
        
        if index < count {
            return self[index]
        } else {
            throw CollectionAccessError.outOfBounds
        }
    }
}
