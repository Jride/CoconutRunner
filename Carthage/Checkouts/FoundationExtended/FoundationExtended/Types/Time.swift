//
//  Time.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public struct Time {
    
    public let seconds: Double
    public var hours: Double {
        return seconds / (60 * 60)
    }
    public var minutes: Double {
        return seconds / 60
    }
    
    public init(days: Double) {
        self.seconds = days * 24 * 60 * 60
    }
    
    public init(hours: Double) {
        self.seconds = hours * 60 * 60
    }
    
    public init(seconds: Double) {
        self.seconds = seconds
    }
    
    public init(minutes: Double) {
        self.seconds = minutes * 60
    }
    
}
