//
//  GameLogic.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 04/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import FoundationExtended

protocol GameLogicEventsDispatcherObserver: class {
    func playerIdleTimeThresholdExceeded()
    func startLevel(withConfig config: LevelConfiguration)
    func gameOver()
    func gameResumed()
}

extension GameLogicEventsDispatcherObserver {
    func playerIdleTimeThresholdExceeded() {}
    func startLevel(withConfig config: LevelConfiguration) {}
    func gameOver() {}
    func gameResumed() {}
}

protocol GameLogicEventsDispatcher {
    func add(observer: GameLogicEventsDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: GameLogicEventsDispatcherObserver)
}

struct LevelConfiguration {
    let level: Int
    let distanceToCompleteLevel: Int
    let playersFullHealth: Int
    let idleTimeThreshold: Time
    let knockCoconutSpawnRate: TimeInterval
    
    func incrementLevel() -> LevelConfiguration {
        
        var newPlayersFullHealth = self.playersFullHealth - 5
        newPlayersFullHealth = newPlayersFullHealth.constrained(min: 15)
        
        var newDistanceToCompleteLevel = self.distanceToCompleteLevel + 25
        newDistanceToCompleteLevel = newDistanceToCompleteLevel.constrained(max: 250)
        
        var thresholdSeconds = self.idleTimeThreshold.seconds - 0.3
        thresholdSeconds = thresholdSeconds.constrained(min: 1)
        
        var newCoconutSpawnRate = self.knockCoconutSpawnRate  - 0.2
        newCoconutSpawnRate = newCoconutSpawnRate.constrained(min: 0.4)
        
        return LevelConfiguration(
            level: self.level + 1,
            distanceToCompleteLevel: self.distanceToCompleteLevel + 25,
            playersFullHealth: newPlayersFullHealth,
            idleTimeThreshold: Time(seconds: thresholdSeconds),
            knockCoconutSpawnRate: newCoconutSpawnRate
        )
    }
    
    static let levelOne = LevelConfiguration(
        level: 1,
        distanceToCompleteLevel: 80,
        playersFullHealth: 30,
        idleTimeThreshold: Time(seconds: 2),
        knockCoconutSpawnRate: 1.3
    )
}

final class GameLogic: GameLogicEventsDispatcher, Observable {
    
    var observerStore = ObserverStore<GameLogicEventsDispatcherObserver>()
    var gameScene: GameScene!
    
    private var idleAccumulatedTime: TimeInterval = 0
    private(set) var currentLevelConfig: LevelConfiguration
    private var isPlayerDead = false
       
    init() {
        // Setting up the first level configuration
        currentLevelConfig = LevelConfiguration.levelOne
    }
    
    func gameSceneDidLoad() {
        Env.gameState.add(observer: self, dispatchBehaviour: .onQueue(.main))
    }
    
    func startGame() {
        isPlayerDead = false
        observerStore.forEach { $0.startLevel(withConfig: self.currentLevelConfig) }
    }
    
    func nextLevel() {
        currentLevelConfig = currentLevelConfig.incrementLevel()
        observerStore.forEach { $0.startLevel(withConfig: self.currentLevelConfig) }
    }
    
    func restartGame() {
        currentLevelConfig = LevelConfiguration.levelOne
        startGame()
    }
    
    func resetToFirstLevel() {
        currentLevelConfig = LevelConfiguration.levelOne
    }
    
    func resumeGame() {
        observerStore.forEach { $0.gameResumed() }
    }
    
    func update(deltaTime: TimeInterval) {
        
        guard isPlayerDead == false else { return }
        
        idleAccumulatedTime += deltaTime
        
        if gameScene.player.isMoving {
            idleAccumulatedTime = 0
        }
        
        if idleAccumulatedTime > currentLevelConfig.idleTimeThreshold.seconds
            && gameScene.player.isMoving == false {
            idleAccumulatedTime = 0
            observerStore.forEach { $0.playerIdleTimeThresholdExceeded() }
        }
        
    }
    
    func resetIdleTimer() {
        idleAccumulatedTime = 0
    }
    
}

extension GameLogic: GameStateDispatcherObserver {
    
    func playerDied() {
        isPlayerDead = true
        observerStore.forEach { $0.gameOver() }
    }
    
}
