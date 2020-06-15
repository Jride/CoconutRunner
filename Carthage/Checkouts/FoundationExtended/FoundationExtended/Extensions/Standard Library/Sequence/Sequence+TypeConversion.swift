//
//  Sequence+TypeConversion.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Sequence where Element: Hashable {
    
    func toSet() -> Set<Element> {
        return Set(self)
    }
}
