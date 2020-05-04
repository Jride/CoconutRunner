//
//  TimeExpiringCache.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public class TimeExpiringCache<T> {
    
    public let duration: CFTimeInterval
    private let getCurrentTime: () -> CFTimeInterval
    private var cachedTime: CFTimeInterval?
    private var cachedValue: T?
    
    public init(duration: CFTimeInterval, getCurrentTime: @escaping () -> CFTimeInterval) {
        self.duration = duration
        self.getCurrentTime = getCurrentTime
    }
    
    public var value: T? {
        get {
            if let cachedValue = cachedValue,
                let cachedTime = cachedTime,
                getCurrentTime() - cachedTime < duration {
                return cachedValue
            } else {
                return nil
            }
        }
        set {
            cachedValue = newValue
            cachedTime = getCurrentTime()
        }
    }
}

