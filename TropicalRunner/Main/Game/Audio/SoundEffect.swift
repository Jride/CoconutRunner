//
//  SoundEffect.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 01/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import AVKit

final class SoundEffect {
    
    var volume: Float = 1.0
    
    private let resource: String
    private var players = [AVAudioPlayer?]()
    
    init(resource: String) {
        self.resource = resource
    }
    
    private func setVolume(_ volume: Float) {
        players.forEach { $0?.volume = volume }
    }
    
    func play() {
        
        players.removeAll(where: { $0?.isPlaying == false })
        
        let path = Bundle.main.path(forResource: resource, ofType: nil).require("unable to load audio")
        let url = URL(fileURLWithPath: path)
        
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.volume = volume
        player?.play()
        
        players.append(player)
    }
    
    func mute() {
        setVolume(0)
    }
    
    func unmute() {
        setVolume(volume)
    }
}
