//
//  AVAudioPlayer+Extensions.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 01/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import AVKit

extension AVAudioPlayer {
    
    public enum AudioPlayerError: Error {
        case fileNotFound
    }
    
    public convenience init(soundFile: SoundFile) throws {
        guard let url = Bundle.main.url(forResource: soundFile.filename, withExtension: soundFile.type) else { throw AudioPlayerError.fileNotFound }
        try self.init(contentsOf: url)
    }
}
