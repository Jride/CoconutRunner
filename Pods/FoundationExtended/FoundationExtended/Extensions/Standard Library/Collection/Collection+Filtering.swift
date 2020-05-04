//
//  Collection+Filtering.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Collection {
    
    public func filterIf(_ condition: Bool, isIncluded: (Element) throws -> Bool) rethrows -> [Self.Element] {
        
        if condition {
            return try self.filter(isIncluded)
        } else {
            return Array(self)
        }
    }
}
