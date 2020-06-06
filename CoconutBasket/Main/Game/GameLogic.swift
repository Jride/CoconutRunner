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
}

extension GameLogicEventsDispatcherObserver {
    func playerIdleTimeThresholdExceeded() {}
    func startLevel(withConfig config: LevelConfiguration) {}
    func gameOver() {}
}

protocol GameLogicEventsDispatcher {
    func add(observer: GameLogicEventsDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: GameLogicEventsDispatcherObserver)
}

struct LevelConfiguration {
    var playersFullHealth: Int
    var idleTimeThreshold: Time
    var knockCoconutSpawnRate: TimeInterval
}

class GameLogic: GameLogicEventsDispatcher, Observable {
    
    var observerStore = ObserverStore<GameLogicEventsDispatcherObserver>()
    var gameScene: GameScene!
    
    private var idleAccumulatedTime: TimeInterval = 0
    private(set) var currentLevelConfig: LevelConfiguration
    private var isPlayerDead = false
       
    init() {
        // Setting up level configuration
        currentLevelConfig = LevelConfiguration(
            playersFullHealth: 40,
            idleTimeThreshold: Time(seconds: 3),
            knockCoconutSpawnRate: 0.7
        )
    }
    
    func gameSceneDidLoad() {
        
        Env.gameState.add(observer: self, dispatchBehaviour: .onQueue(.main))
        startGame()
    }
    
    func startGame() {
        observerStore.forEach { $0.startLevel(withConfig: self.currentLevelConfig) }
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
    
    func playersHealthDidUpdate() {
        
    }
    
    func playerDied() {
        isPlayerDead = true
        observerStore.forEach { $0.gameOver() }
    }
    
}
