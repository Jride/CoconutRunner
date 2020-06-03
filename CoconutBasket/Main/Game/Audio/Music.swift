//
//  Music.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 01/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import AVKit

class Music {
    
    var volume: Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    
    private let resource: String
    private let player: AVAudioPlayer?
    
    init(resource: String) {
        self.resource = resource
        
        let path = Bundle.main.path(forResource: resource, ofType: nil).require("unable to load audio")
        let url = URL(fileURLWithPath: path)
        
        player = try? AVAudioPlayer(contentsOf: url)
        player?.volume = volume
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func loopForever() {
        player?.numberOfLoops = -1
    }
    
    func mute() {
        player?.volume = 0
    }
    
    func unmute() {
        player?.volume = volume
    }
}
