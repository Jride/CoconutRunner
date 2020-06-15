//
//  IndexPathRange.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 18/10/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

/// Represents a range of IndexPaths. The Index path must have exactly 2 elements.
public struct IndexPathRange {
    var startSection: Int
    var endSection: Int
    var startItem: Int
    var endItem: Int
    
    public init(startSection: Int, startItem: Int, endSection: Int, endItem: Int) {
        self.startSection = startSection
        self.endSection = endSection
        self.startItem = startItem
        self.endItem = endItem
    }
    
    public func contains(indexPath: IndexPath) -> Bool {
        
        let section = indexPath[0]
        let item = indexPath[1]
        
        if startSection == endSection {
            return section == startSection && item >= startItem && item <= endItem
        } else {
            if section == startSection {
                return item >= startItem
            } else if section == endSection {
                return item <= endItem
            } else {
                return section > startSection && section < endSection
            }
        }
    }
}
