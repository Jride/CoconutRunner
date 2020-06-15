//
//  Music.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 01/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import AVKit

class Music: NSObject {
    
    var didFinishPlaying: (() -> Void)?
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
        
        super.init()
        
        player?.volume = volume
        player?.delegate = self
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.currentTime = 0
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

extension Music: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlaying?()
    }
}
