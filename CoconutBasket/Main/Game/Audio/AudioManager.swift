//
//  AudioManager.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 30/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    
    private let backgroundMusic = Music(resource: "GrasslandsTheme.mp3")
    private let gameOverMusic = Music(resource: "GameOverMusic.wav")
    private let playerHurt = SoundEffect(resource: "PlayerHurt.mp3")
    private let playerDied = Music(resource: "PlayerDied.wav")
    private let coconutExplosion = SoundEffect(resource: "ImpactFloor.mp3")
    private let bombExplosion = SoundEffect(resource: "Explosion.mp3")
    
    private var mainMusic: Music?
    
    init() {
        
        backgroundMusic.loopForever()
        backgroundMusic.volume = 0.3
        gameOverMusic.loopForever()
        gameOverMusic.volume = 0.4
        coconutExplosion.volume = 0.2
        playerHurt.volume = 0.4
        bombExplosion.volume = 1.0
        
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

extension AudioManager: CollisionEventsDispatcherObserver {
    
    func playerWasHitByEnemy(_ enemy: Enemy) {
        playerHurt.play()
        playCollisionSoundEffect(forEnemy: enemy)
    }
    
    func enemyCollidedWithFloor(_ enemy: Enemy) {
        playCollisionSoundEffect(forEnemy: enemy)
    }
    
}

extension AudioManager: GameLogicEventsDispatcherObserver {
    
    func startLevel(withConfig config: LevelConfiguration) {
        mainMusic?.stop()
        mainMusic = backgroundMusic
        mainMusic?.play()
    }
    
    func gamePaused() {
        mainMusic?.pause()
    }
    
    func gameResumed() {
        mainMusic?.play()
    }
    
    func gameOver() {
        
        mainMusic?.stop()
        mainMusic = playerDied
        playerDied.play()
        playerDied.didFinishPlaying = { [unowned self] in
            self.mainMusic = self.gameOverMusic
            self.gameOverMusic.play()
        }
    }
}
