//
//  EnvironmentConfigurer.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation

class EnvironmentConfigurer {

    static func buildEnvironment() -> Environment {
        
        return Environment(
            audioManager: AudioManager(),
            applicationEventsDispatcher: ApplicationEventsDispatcherImpl(),
            collisionEventsDispatcher: CollisionDetectionManager(),
            gameState: GameState()
        )
        
    }

}
