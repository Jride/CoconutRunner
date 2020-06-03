//
//  GameState.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import FoundationExtended

protocol GameStateDispatcherObserver: class {
    func playersHealthDidUpdate()
}

extension GameStateDispatcherObserver {
    func playersHealthDidUpdate() {}
}

protocol GameStateDispatcher {
    func add(observer: GameStateDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: GameStateDispatcherObserver)
}

class GameState: GameStateDispatcher, Observable {
    
    var observerStore = ObserverStore<GameStateDispatcherObserver>()
    
    private let maxPlayerHealth: Int = 40
    
    private(set) var speed: Double = 0.75
    private(set) var playerHealth: Int
    private(set) var collectedBananas = 0
    
    var yOffset: CGFloat = 0
    var scaleFactor: CGFloat = 1
    
    var playersHealthPercent: CGFloat {
        let percent = CGFloat(playerHealth) / CGFloat(maxPlayerHealth)
        return percent.constrained(min: 0, max: 1)
    }
    
    var isPlayerAlive: Bool {
        return playerHealth > 0
    }
    
    init() {
        
        playerHealth = maxPlayerHealth
        
        DispatchQueue.main.async {
            Env.collisionEventsDispatcher.add(observer: self, dispatchBehaviour: .onQueue(.main))
        }
    }
    
}

extension GameState: CollisionEventsDispatcherObserver {
    
    func playerWasHitByEnemy(_ enemy: Enemy) {
        
        guard isPlayerAlive else { return }
        
        let healthReduction: Int
        switch enemy {
        case .bomb:
            healthReduction = 7
        case .coconut:
            healthReduction = 3
        case .explosion:
            healthReduction = 5
        }
        
        playerHealth = (playerHealth - healthReduction).constrained(min: 0, max: maxPlayerHealth)
        
        observerStore.forEach { $0.playersHealthDidUpdate() }
    }
}
