//
//  Sequence+Numeric.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 30/05/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

public extension Sequence where Element: Numeric {
    
    func sum() -> Element {
        return self.reduce(0, +)
    }
}
