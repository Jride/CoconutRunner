//
//  TimeFormatter.swift
//  FoundationExtended
//
//  Created by Josh Rideout on 15/02/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation
public class TimeFormatter {
    
    struct Duration {
        let hours: Int
        let minutes: Int
        let seconds: Int
        
        static func from(seconds: Double) -> Duration {
            
            var seconds = seconds
            
            let hours = seconds / (60 * 60)
            seconds = seconds.truncatingRemainder(dividingBy: (60 * 60))
            
            let minutes = seconds / 60
            seconds = seconds.truncatingRemainder(dividingBy: 60)
            
            return Duration(hours: Int(hours),
                            minutes: Int(minutes),
                            seconds: Int(seconds))
            
        }
    }
    
    private let seconds: Double
    private let duration: Duration
    
    public init(seconds: Double) {
        self.seconds = (seconds.isNaN || seconds.isInfinite) ? 0 : seconds
        self.duration = Duration.from(seconds: self.seconds)
    }
    
    public func playerDurationFormat() -> String {
        return String(format: "%02d:%02d:%02d", duration.hours, duration.minutes, duration.seconds)
    }
}
