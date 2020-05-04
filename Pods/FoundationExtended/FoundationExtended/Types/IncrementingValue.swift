//
//  IncrementingValue.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 03/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

/// Returns values incremented by a custom closure
public class IncrementingValue<T> {
    
    /// The last value returned by a call to next()
    public var current: T
    
    private let increment: (T) -> T
    private var hasReturnedFirstValue = false
    
    /// Initalise with a current value and an incrementing closure
    ///
    /// - Parameters:
    ///   - initialValue: Value to be returned on the first call to next()
    ///   - increment: Closure to calculate the next value
    public init(initialValue: T, increment: @escaping (T) -> T) {
        
        self.current = initialValue
        self.increment = increment
    }
    
    
    /// Returns the next value, incremented by the passed in closure. On the first call
    /// will return the initial value
    ///
    /// - Returns: The next value
    @discardableResult public func next() -> T {
        
        guard hasReturnedFirstValue else {
            hasReturnedFirstValue = true
            return current
        }
        
        current = self.increment(current)
        return current
    }
}
