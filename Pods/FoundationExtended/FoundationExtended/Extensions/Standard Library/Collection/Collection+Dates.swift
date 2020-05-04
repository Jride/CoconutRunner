//
//  Collection+Dates.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Collection where Element == Date {
    
    var latestDate: Date? {
        return self.max { $0 < $1 }
    }
    
}
