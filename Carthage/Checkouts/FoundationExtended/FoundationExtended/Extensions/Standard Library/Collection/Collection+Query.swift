//
//  Collection+Query.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - isAscending / isDescending

extension Collection where Element: Comparable {
    
    public var isAscending: Bool {
        
        var previousItem: Element?
        
        for item in self {
            
            if let previous = previousItem, previous > item {
                return false
            }
            
            previousItem = item
        }
        
        return true
    }
    
    public var isDescending: Bool {
        
        var previousItem: Element?
        
        for item in self {
            
            if let previous = previousItem, previous < item {
                return false
            }
            
            previousItem = item
        }
        
        return true
    }
}
