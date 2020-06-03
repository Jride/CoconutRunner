//
//  GameObjectsLayers.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 02/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import SpriteKit

struct ZPosition {
    
    struct Background {
        static let backClouds: CGFloat = -99
        static let frontClouds: CGFloat = -98
        static let main: CGFloat = -97
    }
    
    static let monkey: CGFloat = 5
    static let floor: CGFloat = 10
    static let palmTree: CGFloat = 15
    static let banana: CGFloat = 17
    
    struct Coconut {
        static let top: CGFloat = 20
        static let left: CGFloat = 25
        static let right: CGFloat = 30
    }
    
    static let bombs: CGFloat = 35
    static let explosions: CGFloat = 35
    
    static let player: CGFloat = 40
    
}
