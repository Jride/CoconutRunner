//
//  Background.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 13/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    static let originalSize = SKTexture(imageNamed: "background").size()
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "background")
        super.init(texture: texture, color: .white, size: size)
        
        zPosition = ZPosition.Background.main
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContinuousMovingNode: SKNode {
    
    private let movementSpeed: TimeInterval
    
    init(movementSpeed: TimeInterval) {
        self.movementSpeed = movementSpeed
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        let amountToMove = deltaTime * movementSpeed
        position.x -= CGFloat(amountToMove)
    }
    
}

class BackgroundCloudFront: SKSpriteNode {
    
    static let originalSize = SKTexture(imageNamed: "BackgroundCloudLayerA").size()
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "BackgroundCloudLayerA")
        super.init(texture: texture, color: .white, size: size)
        
        zPosition = ZPosition.Background.frontClouds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackgroundCloudBack: SKSpriteNode {
    
    static let originalSize = SKTexture(imageNamed: "BackgroundCloudLayerB").size()
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "BackgroundCloudLayerB")
        super.init(texture: texture, color: .white, size: size)
        
        zPosition = ZPosition.Background.backClouds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
