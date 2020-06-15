//
//  FreeFunctions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 27/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public func repeated(times: Int, handler: () -> Void) {
    assert(times.isPositive, "Times must not be negative")
    
    if times <= 0 {
        return
    }
    
    for _ in (0..<times) {
        handler()
    }
}

public func NotImplemented() -> Never {
    fatalError("Not Implemented")
}

