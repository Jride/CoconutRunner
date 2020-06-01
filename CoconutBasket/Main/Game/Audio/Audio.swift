//
//  Audio.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 01/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation

public protocol SoundFile {
    var filename: String { get }
    var type: String { get }
}

public struct Music: SoundFile {
    public var filename: String
    public var type: String
}

public struct Effect: SoundFile {
    public var filename: String
    public var type: String
}

struct Audio {
    
    struct MusicFiles {
        static let levelOne = Music(filename: "GrasslandsTheme", type: "mp3")
    }
    
    struct EffectFiles {
        static let playerHurt = Effect(filename: "PlayerHurt", type: "mp3")
        static let coconutExplosion = Effect(filename: "ImpactFloor", type: "mp3")
        static let bombExplosion = Effect(filename: "Explosion", type: "mp3")
    
    }
}
