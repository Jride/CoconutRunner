//
//  Array+Accessors.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Maybe subscript

extension Array {
    
    public subscript(maybe index: Int) -> Element? {
        get {
            if index > count - 1 {
                return nil
            } else if index < 0 {
                return nil
            } else {
                return self[index]
            }
        }
    }
}

// MARK: - Pop

extension Array {
    
    public mutating func popFirst() -> Element? {
        
        if self.isEmpty {
            return nil
        } else {
            return self.remove(at: 0)
        }
    }
}

// MARK: - Numbered

extension Array {
    
    public var second: Element? {
        return self[maybe: 1]
    }
}
