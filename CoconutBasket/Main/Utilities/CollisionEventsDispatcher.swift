//
//  CollisionEventsDispatcher.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import Foundation

enum EnemyType {
    case coconut(Coconut)
    case bomb(Bomb)
    case explosion(SKNode)
}

protocol CollisionEventsDispatcherObserver: class {
    func playerWasHitByEnemy(_ enemyType: EnemyType)
    func enemyCollidedWithFloor(_ enemyType: EnemyType)
}

extension CollisionEventsDispatcherObserver {
    func playerWasHitByEnemy(_ enemyType: EnemyType) {}
    func enemyCollidedWithFloor(_ enemyType: EnemyType) {}
}

protocol CollisionEventsDispatcher {
    func add(observer: CollisionEventsDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: CollisionEventsDispatcherObserver)
}
