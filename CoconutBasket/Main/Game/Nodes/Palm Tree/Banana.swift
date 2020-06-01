//
//  Banana.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 07/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Banana: SKSpriteNode {
    
    static func size() -> CGSize {
        let textureSize = SKTexture(imageNamed: "banana").size()
        let ratio = textureSize.width / textureSize.height
        let newHeight: CGFloat = 35 * Env.gameState.scaleFactor
        return CGSize(width: newHeight * ratio, height: newHeight)
    }
    
    static func newInstance() -> Banana {
        
        let newBanana = Banana(imageNamed: "banana")
        
        newBanana.size = Self.size()
        newBanana.zPosition = 1
        
        newBanana.setupPhysicsBody()
        
        return newBanana
    }
    
    var palmTree: PalmTree?
    
    private func setupPhysicsBody() {
    
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = CollisionType.banana.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.affectedByGravity = false
        
    }
}
