//
//  FloatingPoint+Interpolation.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 20/11/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension FloatingPoint {
    
    /// Returns a new value linearly interpolated to `other` by amount `t`
    ///
    /// - Parameters:
    ///   - other: The value to interpolate to
    ///   - t: The amount of interpolation to `other`
    /// - Returns: Interpolated value
    func interpolated(to other: Self, t: Self) -> Self {
        return self + (other - self)*t
    }
}
