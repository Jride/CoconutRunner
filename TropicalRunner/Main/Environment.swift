//
//  Environment.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import FoundationExtended

var Env = EnvironmentConfigurer.buildEnvironment()

struct Environment {
    var audioManager: AudioManager
    var applicationEventsDispatcher: ApplicationEventsDispatcher
    var collisionEventsDispatcher: CollisionEventsDispatcher
    var date: DateClosure
    var device: DeviceProtocol
    var gameLogic: GameLogic
    var gameState: GameState
}
