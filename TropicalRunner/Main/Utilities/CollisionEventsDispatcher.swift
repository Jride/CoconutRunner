//
//  CollisionEventsDispatcher.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import Foundation

enum Enemy {
    case coconut(Coconut)
    case bomb(Bomb)
    case explosion(SKNode)
}

enum PowerUp {
    case banana
}

protocol CollisionEventsDispatcherObserver: class {
    func playerWasHitByEnemy(_ enemy: Enemy)
    func playerCollectedPowerUp(_ powerUp: PowerUp)
    func enemyCollidedWithFloor(_ enemy: Enemy)
}

extension CollisionEventsDispatcherObserver {
    func playerWasHitByEnemy(_ enemy: Enemy) {}
    func playerCollectedPowerUp(_ powerUp: PowerUp) {}
    func enemyCollidedWithFloor(_ enemy: Enemy) {}
}

protocol CollisionEventsDispatcher {
    func add(observer: CollisionEventsDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: CollisionEventsDispatcherObserver)
}
