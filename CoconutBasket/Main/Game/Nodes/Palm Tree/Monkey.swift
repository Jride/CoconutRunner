//
//  Monkey.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 01/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Monkey: GameSpriteNode {
    
    var scale: CGFloat {
        Env.gameState.scaleFactor
    }
    
    static func size() -> CGSize {
        let textureSize = SKTexture(imageNamed: "monkey_arms_up1").size()
        let ratio = textureSize.width / textureSize.height
        let newHeight: CGFloat = 80 * Env.gameState.scaleFactor
        return CGSize(width: newHeight * ratio, height: newHeight)
    }
    
    static func newInstance() -> Monkey {
        
        let newMonkey = Monkey(imageNamed: "monkey_arms_up1")
        
        newMonkey.size = Self.size()
        newMonkey.zPosition = ZPosition.monkey
        newMonkey.setup()
        return newMonkey
    }
    
    var palmTree: PalmTree? {
        didSet {
            guard let tree = palmTree else { return }
            bomb?.palmTree = tree
        }
    }
    var bomb: Bomb?
    
    private var dropAction: SKAction!
    
    private func setup() {
        
        let textures: [SKTexture] = [
            .init(imageNamed: "monkey_arms_up1"),
            .init(imageNamed: "monkey_arms_up2")
        ]
        
        dropAction = .sequence([
            .animate(with: textures, timePerFrame: 0.1),
            .wait(forDuration: 1.0),
            .setTexture(.init(imageNamed: "monkey_cross_arms")),
            .wait(forDuration: 0.2),
            .moveBy(x: 20 * scale, y: -72 * scale, duration: 0.4),
            .wait(forDuration: 0.4),
            .run {
                self.removeFromParent()
            }
        ])
        
        let bomb = Bomb.newInstance()
        bomb.position = CGPoint(x: position.x + (4 * scale),
                                y: position.y + size.height/2 + (7 * scale))
        
//        bomb.zPosition = ZPosition.monkey + 2
        bomb.ignite()
        addChild(bomb)
        self.bomb = bomb
        
//        alpha = 0
    }
    
    func runAnimation() {
        
        
        
    }
    
    func runDropAnimation() {
        run(dropAction)
    }
}
