//
//  CollisionType.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 03/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation

enum CollisionType: UInt32 {
    case banana = 1
    case bomb = 2
    case coconut = 4
    case explosionRadius = 8
    case floor = 16
    case player = 32
}
