//
//  AudioPlayer.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 30/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import AVKit

protocol AudioPlayer {
    
    var musicVolume: Float { get set }
    var shouldLoopMusic: Bool { get set }
    func play(music: Music)
    func pause(music: Music)
    
    var effectsVolume: Float { get set }
    func play(effect: Effect)
}

class AudioPlayerImpl {
    
    private var currentMusicPlayer: AVAudioPlayer?
    private var currentEffectPlayer: AVAudioPlayer?
    var musicVolume: Float = 1.0 {
        didSet { currentMusicPlayer?.volume = musicVolume }
    }
    var shouldLoopMusic: Bool = false {
        didSet { currentMusicPlayer?.numberOfLoops = shouldLoopMusic ? -1 : 1 }
    }
    var effectsVolume: Float = 1.0
    
    init() {
        DispatchQueue.main.async {
            Env.collisionEventsDispatcher.add(observer: self, dispatchBehaviour: .onQueue(.main))
        }
    }
}

extension AudioPlayerImpl: AudioPlayer {
    
    func play(music: Music) {
        currentMusicPlayer?.stop()
        guard let newPlayer = try? AVAudioPlayer(soundFile: music) else { return }
        newPlayer.volume = musicVolume
        newPlayer.numberOfLoops = shouldLoopMusic ? -1 : 1
        newPlayer.play()
        currentMusicPlayer = newPlayer
    }
    
    func pause(music: Music) {
        currentMusicPlayer?.pause()
    }
    
    func play(effect: Effect) {
        guard let effectPlayer = try? AVAudioPlayer(soundFile: effect) else { return }
        effectPlayer.volume = effectsVolume
        effectPlayer.play()
        currentEffectPlayer = effectPlayer
    }
}

extension AudioPlayerImpl: CollisionEventsDispatcherObserver {
    
    func playerWasHitByEnemy(_ enemyType: EnemyType) {
        let prevVolumeLevel = effectsVolume
        effectsVolume = 0.5
        play(effect: Audio.EffectFiles.playerHurt)
        effectsVolume = prevVolumeLevel
    }
    
    func enemyCollidedWithFloor(_ enemyType: EnemyType) {
        switch enemyType {
        case .bomb:
            play(effect: Audio.EffectFiles.bombExplosion)
        case .coconut:
            play(effect: Audio.EffectFiles.coconutExplosion)
        case .explosion:
            assertionFailure("Explosion radius should not collide with the floor")
        }
    }
    
}
