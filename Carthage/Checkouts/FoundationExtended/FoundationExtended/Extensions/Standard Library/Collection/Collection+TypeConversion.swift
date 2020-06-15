//
//  Collection+TypeConversion.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 05/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Collection {
    
    public func toArray() -> [Element] {
        return Array(self)
    }
}
