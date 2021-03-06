//
//  AudioManager.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 30/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct GameSoundEffects {
    static let scoreAddVersionOne = SoundEffect(resource: "ScoreAddV1.mp3")
    static let scoreAddVersionTwo = SoundEffect(resource: "ScoreAddV2.mp3")
    static let scoreSubtract = SoundEffect(resource: "ScoreSubtract.mp3")
}

final class AudioManager {
    
    // Music
    private let backgroundMusic = Music(resource: "GrasslandsTheme.mp3")
    private let gameOverMusic = Music(resource: "GameOverMusic.wav")
    private let playerDied = Music(resource: "PlayerDied.wav")
    private let menuMusic = Music(resource: "GameOverMusic.wav")
    
    // Sound Effects
    private let playerHurt = SoundEffect(resource: "PlayerHurt.mp3")
    private let coconutExplosion = SoundEffect(resource: "ImpactFloor.mp3")
    private let bombExplosion = SoundEffect(resource: "Explosion.mp3")
    private let collectItem = SoundEffect(resource: "CollectItem.wav")
    
    private var gameMusic: Music?
    
    init() {
        
        backgroundMusic.loopForever()
        backgroundMusic.volume = 0.3
        gameOverMusic.loopForever()
        gameOverMusic.volume = 0.4
        menuMusic.loopForever()
        menuMusic.volume = 0.4
        coconutExplosion.volume = 0.2
        playerHurt.volume = 0.4
        bombExplosion.volume = 1.0
        collectItem.volume = 0.2
        
        DispatchQueue.main.async {
            Env.collisionEventsDispatcher.add(observer: self, dispatchBehaviour: .onQueue(.main))
            Env.gameLogic.add(observer: self, dispatchBehaviour: .onQueue(.main))
        }
    }
    
    private func playCollisionSoundEffect(forEnemy enemy: Enemy) {
        switch enemy {
        case .bomb:
            bombExplosion.play()
        case .coconut:
            coconutExplosion.play()
        case .explosion:
            print("No collision sound effect for enemy")
        }
    }
    
}

// MARK: - Public

extension AudioManager {
    
    func mainMenuPresented() {
        gameMusic?.stop()
        gameMusic = nil
        menuMusic.play()
    }
    
    func pauseMenuPresented() {
        gameMusic?.pause()
        menuMusic.play()
    }
    
}

// MARK: - CollisionEventsDispatcherObserver
extension AudioManager: CollisionEventsDispatcherObserver {
    
    func playerWasHitByEnemy(_ enemy: Enemy) {
        playerHurt.play()
        playCollisionSoundEffect(forEnemy: enemy)
        UIDevice.vibrate()
    }
    
    func playerCollectedPowerUp(_ powerUp: PowerUp) {
        collectItem.play()
    }
    
    func enemyCollidedWithFloor(_ enemy: Enemy) {
        playCollisionSoundEffect(forEnemy: enemy)
    }
    
}

// MARK: - GameLogicEventsDispatcherObserver
extension AudioManager: GameLogicEventsDispatcherObserver {
    
    func startLevel(withConfig config: LevelConfiguration) {
        
        guard config.level == 1 else { return }
        
        menuMusic.stop()
        gameMusic?.stop()
        gameMusic = backgroundMusic
        gameMusic?.play()
    }
    
    func gameResumed() {
        menuMusic.pause()
        gameMusic?.play()
    }
    
    func gameOver() {
        
        gameMusic?.stop()
        gameMusic = playerDied
        playerDied.play()
        playerDied.didFinishPlaying = { [unowned self] in
            self.gameMusic = self.gameOverMusic
            self.gameOverMusic.play()
        }
    }
}
