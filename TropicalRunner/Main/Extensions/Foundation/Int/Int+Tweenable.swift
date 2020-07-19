//
//  Int+Tweenable.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 12/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import TweenKit

extension Int: Tweenable {
    
    public func lerp(t: Double, end: Int) -> Int {
        
        if self > end {
            let amountToTween = self - end
            let move = Int(Double(amountToTween) * t)
            return (self - move).constrained(min: end)
        } else {
            let amountToTween = end - self
            let move = Int(Double(amountToTween) * t)
            return (self + move).constrained(max: end)
        }
    }
    
    public func distanceTo(other: Int) -> Double {
        fatalError("Not implemented")
    }
    
}
