//
//  Background.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 13/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Background: GameNode {
    
    static let originalSize = SKTexture(imageNamed: "background").size()
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "background")
        super.init(texture: texture, color: .white, size: size)
        
        zPosition = -2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackgroundCloudFront: SKSpriteNode {
    
    static let originalSize = SKTexture(imageNamed: "BackgroundCloudLayerA").size()
    private let cloudSpeed: TimeInterval = 30
    var isAnimating = false
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "BackgroundCloudLayerA")
        super.init(texture: texture, color: .white, size: size)
        
        zPosition = -3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        
        guard isAnimating else { return }
        
        let amountToMove = deltaTime * cloudSpeed
        position.x -= CGFloat(amountToMove)
    }
}

class BackgroundCloudBack: SKSpriteNode {
    
    static let originalSize = SKTexture(imageNamed: "BackgroundCloudLayerB").size()
    private let cloudSpeed: TimeInterval = 10
    var isAnimating = false
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "BackgroundCloudLayerB")
        super.init(texture: texture, color: .white, size: size)
        
        zPosition = -4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        
        guard isAnimating else { return }
        
        let amountToMove = deltaTime * cloudSpeed
        position.x -= CGFloat(amountToMove)
    }
}
