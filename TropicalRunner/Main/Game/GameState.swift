//
//  GameState.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import Foundation
import FoundationExtended

protocol GameStateDispatcherObserver: class {
    func playersHealthDidUpdate()
    func playersDistanceStatsDidUpdate()
    func playerDied()
    func resetGameState()
}

extension GameStateDispatcherObserver {
    func playersHealthDidUpdate() {}
    func playersDistanceStatsDidUpdate() {}
    func playerDied() {}
    func resetGameState() {}
}

protocol GameStateDispatcher {
    func add(observer: GameStateDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: GameStateDispatcherObserver)
}

final class GameState: GameStateDispatcher, Observable {
    
    struct PlayersDistanceStats {
        var overallDistance: Int = 0
        var currentLevelDistance: Int = 0
        var distanceToCompleteLevel: Int = 0
        
        var levelsDistanceProgress: CGFloat {
            guard distanceToCompleteLevel > 0 else { return 0 }
            
            let percent = CGFloat(currentLevelDistance) / CGFloat(distanceToCompleteLevel)
            return percent.constrained(min: 0, max: 1)
        }
        
        mutating func bumpDistance(runningDistance: Int) {
            self.currentLevelDistance += runningDistance
            self.overallDistance += runningDistance
        }
    }
    
    var observerStore = ObserverStore<GameStateDispatcherObserver>()
    
    private(set) var speed: Double = 0.75
    private(set) var playerHealth: Int!
    private(set) var totalDamageTaken = 0
    private(set) var totalBananasCollected = 0
    private var playersFullHealth: Int!
    private(set) var playersHealthPercent: CGFloat = 1
    private(set) var playersDistanceStats = PlayersDistanceStats()
    
    var scaleFactor: CGFloat = 1
    
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
            
            self.playersDistanceStats = .init(
                overallDistance: 0,
                currentLevelDistance: 0,
                distanceToCompleteLevel: levelConfig.distanceToCompleteLevel
            )
        }
        
    }
    
    private func configure(withLevelConfig config: LevelConfiguration) {
        playersDistanceStats.currentLevelDistance = 0
        if config.level == 1 {
            playersDistanceStats.overallDistance = 0
        }
        if config.level > 1 {
            playersDistanceStats.distanceToCompleteLevel = config.distanceToCompleteLevel
        }
        
        playerHealth = config.playersFullHealth
        playersFullHealth = config.playersFullHealth
        
        let percent = CGFloat(playerHealth) / CGFloat(playersFullHealth)
        playersHealthPercent = percent.constrained(min: 0, max: 1)
    }
    
    func reset() {
        Env.gameLogic.resetToFirstLevel()
        configure(withLevelConfig: Env.gameLogic.currentLevelConfig)
        observerStore.forEach { $0.resetGameState() }
        totalDamageTaken = 0
        totalBananasCollected = 0
    }
    
}

extension GameState: CollisionEventsDispatcherObserver {
    
    func playerWasHitByEnemy(_ enemy: Enemy) {
        
        guard isPlayerAlive else { return }
        
        let damageTaken: Int
        switch enemy {
        case .bomb:
            damageTaken = 7
        case .coconut:
            damageTaken = 3
        case .explosion:
            damageTaken = 5
        }
        
        totalDamageTaken += damageTaken
        playerHealth = (playerHealth - damageTaken).constrained(min: 0, max: playersFullHealth)
        
        let percent = CGFloat(playerHealth) / CGFloat(playersFullHealth)
        playersHealthPercent = percent.constrained(min: 0, max: 1)
        
        observerStore.forEach { $0.playersHealthDidUpdate() }
        
        if isPlayerAlive == false {
            observerStore.forEach { $0.playerDied() }
        }
    }
    
    func playerCollectedPowerUp(_ powerUp: PowerUp) {
        
        guard isPlayerAlive else { return }
        
        switch powerUp {
        case .banana:
            totalBananasCollected += 1
        }
        
    }
}

extension GameState: GameLogicEventsDispatcherObserver {
    
    func startLevel(withConfig config: LevelConfiguration) {
        
        configure(withLevelConfig: config)
        
        observerStore.forEach {
            $0.playersHealthDidUpdate()
            $0.playersDistanceStatsDidUpdate()
        }
    }
}

extension GameState: PlayerEventsDispatcherObserver {
    
    func playerDidStopMoving() {
        
        guard isPlayerAlive else { return }
        
        playersDistanceStats.bumpDistance(runningDistance: 5)
        
        if playersDistanceStats.levelsDistanceProgress == 1 {
            // TODO: Implement level complete
            // Level Complete
            Env.gameLogic.nextLevel()
        }
        
        observerStore.forEach { $0.playersDistanceStatsDidUpdate() }
    }
    
}
