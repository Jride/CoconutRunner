//
//  CollisionType.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 03/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation

enum CollisionType: UInt32 {
    case bomb = 1
    case coconut = 2
    case explosionRadius = 4
    case floor = 8
    case player = 16
}
