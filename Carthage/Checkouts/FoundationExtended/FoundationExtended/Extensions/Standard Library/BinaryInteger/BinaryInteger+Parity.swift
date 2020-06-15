//
//  BinaryInteger+Parity.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 03/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension BinaryInteger {
    
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return !isEven
    }
}
