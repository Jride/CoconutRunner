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
        
        let newMonkey = Monkey(imageNamed: "monkey_head")
        
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
    
    private func setup() {
        
        let bomb = Bomb.newInstance()
        bomb.position = CGPoint(x: position.x + (4 * scale),
                                y: position.y + size.height/2 + (7 * scale))
        
        bomb.zPosition = ZPosition.monkey + 2
        bomb.alpha = 0
        addChild(bomb)
        self.bomb = bomb
    }
    
    func dropBombAnimation(dropBomb: @escaping () -> Void) {
        
        let originalPosition = position
        
        let textures: [SKTexture] = [
            .init(imageNamed: "monkey_arms_up1"),
            .init(imageNamed: "monkey_arms_up2")
        ]
        
        let dropAction = SKAction.sequence([
            .animate(with: textures, timePerFrame: 0.1),
            .wait(forDuration: 1.0),
            .setTexture(.init(imageNamed: "monkey_cross_arms")),
            .wait(forDuration: 0.2),
            .group([
                .moveBy(x: 20 * scale, y: -72 * scale, duration: 0.4),
                .scale(by: 0.7, duration: 0.4)
            ])
        ])
        
        let ratio = size.width / size.height
        let newSize = CGSize(width: 30 * ratio, height: 30)
        
        let hide = SKAction.group([
            .moveBy(x: 20 * scale, y: -50 * scale, duration: 0.3),
            .scale(to: newSize, duration: 0.3)
        ])
        
        let show = SKAction.group([
            .moveBy(x: -20 * scale, y: 90 * scale, duration: 0.4),
            .scale(to: Self.size(), duration: 0.4)
        ])
        
        run(.sequence([
            .wait(forDuration: 1),
            .moveBy(x: 0, y: 40 * scale, duration: 0.3),
            .wait(forDuration: 1.5),
            hide,
            .setTexture(SKTexture(imageNamed: "monkey_arms_up1")),
            .run {
                self.bomb?.alpha = 1
                self.bomb?.ignite()
            },
            show,
            .wait(forDuration: 0.5),
            .run { dropBomb() },
            dropAction,
            .setTexture(SKTexture(imageNamed: "monkey_head")),
            .move(to: originalPosition, duration: 0),
            .run {
                self.dropBombAnimation(dropBomb: dropBomb)
            }
        ]))
    }
    
}