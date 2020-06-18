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
    var level: Int
    var distanceToCompleteLevel: Int
    var playersFullHealth: Int
    var idleTimeThreshold: Time
    var knockCoconutSpawnRate: TimeInterval
    
    static let levelOne = LevelConfiguration(
        level: 1,
        distanceToCompleteLevel: 50,
        playersFullHealth: 5,
        idleTimeThreshold: Time(seconds: 2),
        knockCoconutSpawnRate: 0.7
    )
}

class GameLogic: GameLogicEventsDispatcher, Observable {
    
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
    
    func restartGame() {
        currentLevelConfig = LevelConfiguration.levelOne
        startGame()
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

extension GameLogic: MenuDispatcherObserver {
    
    func pauseMenuDismissed() {
        
    }
    
}
