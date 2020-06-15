//
//  Array+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

// MARK: - Flattened

extension Array {
    
    public func flattened<T>() -> [T] where Element == T? {
        return compactMap { $0 }
    }
}
