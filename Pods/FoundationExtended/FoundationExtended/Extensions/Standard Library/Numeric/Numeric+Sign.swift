//
//  Numeric+Sign.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 05/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Numeric where Self: Comparable {
    
    var isNegative: Bool {
        return self < 0
    }
    
    var isPositive: Bool {
        return self >= 0
    }
}

