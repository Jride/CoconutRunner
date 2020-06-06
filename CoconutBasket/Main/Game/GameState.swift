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
    func playerDied()
}

extension GameStateDispatcherObserver {
    func playersHealthDidUpdate() {}
    func playerDied() {}
}

protocol GameStateDispatcher {
    func add(observer: GameStateDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: GameStateDispatcherObserver)
}

class GameState: GameStateDispatcher, Observable {
    
    var observerStore = ObserverStore<GameStateDispatcherObserver>()
    
    private(set) var speed: Double = 0.75
    private(set) var playerHealth: Int!
    private var playersFullHealth: Int!
    
    var scaleFactor: CGFloat = 1
    
    var playersHealthPercent: CGFloat = 100
    
    var isPlayerAlive: Bool {
        return playerHealth > 0
    }
    
    init() {
        
        DispatchQueue.main.async {
            Env.collisionEventsDispatcher.add(observer: self, dispatchBehaviour: .onQueue(.main))
            Env.gameLogic.add(observer: self, dispatchBehaviour: .onQueue(.main))
            
            let levelConfig = Env.gameLogic.currentLevelConfig
            self.playerHealth = levelConfig.playersFullHealth
            self.playersFullHealth = levelConfig.playersFullHealth
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
        
        playerHealth = (playerHealth - healthReduction).constrained(min: 0, max: playersFullHealth)
        
        let percent = CGFloat(playerHealth) / CGFloat(playersFullHealth)
        playersHealthPercent = percent.constrained(min: 0, max: 1)
        
        observerStore.forEach { $0.playersHealthDidUpdate() }
        
        if isPlayerAlive == false {
            observerStore.forEach { $0.playerDied() }
        }
    }
}

extension GameState: GameLogicEventsDispatcherObserver {
    
    func startLevel(withConfig config: LevelConfiguration) {
        playerHealth = config.playersFullHealth
        playersFullHealth = config.playersFullHealth
    }
}
