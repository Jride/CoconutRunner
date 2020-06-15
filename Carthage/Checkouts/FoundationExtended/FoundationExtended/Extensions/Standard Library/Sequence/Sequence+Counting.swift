//
//  Sequence+Counting.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Counting

extension Sequence {
    
    public func count(where matches: (Element) -> Bool) -> Int {
        var count = 0
        for element in self where matches(element) {
            count += 1
        }
        return count
    }
    
}
