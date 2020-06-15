//
//  Numeric+Constrained.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Numeric where Self: Comparable {
    
    func constrained(min minimumValue: Self) -> Self {
        return Swift.max(self, minimumValue)
    }
    
    func constrained(max maximumValue: Self) -> Self {
        return Swift.min(self, maximumValue)
    }
    
    func constrained(min minimumValue: Self, max maximumValue: Self) -> Self {
        return  Swift.max(Swift.min(self, maximumValue), minimumValue)
    }
}
