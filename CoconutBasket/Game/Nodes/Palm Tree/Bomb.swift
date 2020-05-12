//
//  Bomb.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 02/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Bomb: SKSpriteNode {
    
    static func size() -> CGSize {
        let textureSize = SKTexture(imageNamed: "bomb").size()
        let ratio = textureSize.width / textureSize.height
        let newHeight: CGFloat = 55 * GameState.shared.scaleFactor
        return CGSize(width: newHeight * ratio, height: newHeight)
    }
    
    static func newInstance() -> Bomb {
        
        let newBomb = Bomb()
        newBomb.size = Self.size()
        newBomb.zPosition = 1
        
        return newBomb
    }
    
    var palmTree: PalmTree?
    private var igniteAction: SKAction!
    
    convenience init() {
        self.init(imageNamed: "bomb")
        setup()
    }
    
    private func setup() {
        
        let textures: [SKTexture] = [
            .init(imageNamed: "bomb0"),
            .init(imageNamed: "bomb2"),
            .init(imageNamed: "bomb0"),
            .init(imageNamed: "bomb1"),
            .init(imageNamed: "bomb2")
        ]
        
        igniteAction = .animate(with: textures, timePerFrame: 0.1)
    }
    
    func ignite() {
        run(.repeatForever(igniteAction), withKey: "ignite")
    }
}
