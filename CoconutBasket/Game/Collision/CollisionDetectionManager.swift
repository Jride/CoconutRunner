//
//  CollisionDetectionManager.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 03/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import FoundationExtended

class CollisionDetectionManager: NSObject, SKPhysicsContactDelegate {
    
    private var isPlayerAlive: Bool { return GameState.shared.isPlayerAlive }
    
    private var gameState: GameState {
        return GameState.shared
    }
    
    private var gameScene: GameScene
    private var playerHitSoundAction: SKAction!
    private var floorHitSoundAction: SKAction!
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
        
        playerHitSoundAction = .playSoundFileNamed("impactPlayer", waitForCompletion: false)
        floorHitSoundAction = .playSoundFileNamed("impactFloor", waitForCompletion: false)
    }
    
    private func makeExplosion(withRadius radius: CGFloat) -> SKNode {
        
        let explosionCircle = SKNode()
        
//        explosionCircle.fillColor = .red
        explosionCircle.name = "explosionRadius"
        explosionCircle.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        explosionCircle.physicsBody?.isDynamic = true
        explosionCircle.physicsBody?.categoryBitMask = CollisionType.explosionRadius.rawValue
        explosionCircle.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        explosionCircle.physicsBody?.collisionBitMask = 0
        explosionCircle.physicsBody?.affectedByGravity = false
        
        return explosionCircle
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard
            let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node else {
                return
        }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "player" {
            
            guard isPlayerAlive else { return }
            
            if let coconut = firstNode as? Coconut, let tree = coconut.palmTree {
                
                gameState.playerLives -= 1
                
                if let explosion = SKEmitterNode(fileNamed: "CoconutExplosion") {
                    explosion.position = firstNode.position
                    explosion.zPosition = 3
                    tree.addChild(explosion)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        explosion.removeFromParent()
                    }
                }
                
            } else if let bomb = firstNode as? Bomb, let tree = bomb.palmTree {
                
                // TODO: Add game logic for getting hit by bomb
                
                gameState.playerLives -= 3
                
                if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                    explosion.position = firstNode.position
                    explosion.zPosition = 3
                    tree.addChild(explosion)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        explosion.removeFromParent()
                    }
                }
                
            } else if firstNode.name == "explosionRadius" {
                
                print("EXPLOSION HIT PLAYER!!!")
                
            } else {
                return
            }
            
            gameScene.run(playerHitSoundAction)
            gameScene.player.hit()
            
            if gameState.playerLives == 0 {
                gameScene.gameOver()
                secondNode.removeFromParent()
            }
            
            firstNode.removeFromParent()
            
        } else if secondNode.name == "floor" {
            
            if let coconut = firstNode as? Coconut, let tree = coconut.palmTree {
                
                if let explosion = SKEmitterNode(fileNamed: "CoconutExplosionUp") {
                    explosion.position = firstNode.position
                    explosion.zPosition = 3
                    tree.addChild(explosion)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        explosion.removeFromParent()
                    }
                }
                
            } else if let bomb = firstNode as? Bomb, let tree = bomb.palmTree {
                
                if let explosion = SKEmitterNode(fileNamed: "ExplosionUp") {
                    explosion.position = firstNode.position
                    explosion.zPosition = 3
                    tree.addChild(explosion)
                    
                    let duration = TimeInterval(explosion.particleLifetime) / 2
                    let maxRadius = explosion.particlePositionRange.dx
                    
                    var explosionCircle = makeExplosion(withRadius: 10)
                    explosionCircle.position = firstNode.position
                    tree.addChild(explosionCircle)
                    
                    explosionCircle.run(
                        .sequence([
                            .scale(to: ((maxRadius*2) / 10), duration: duration),
//                            .resize(toWidth: maxRadius*2, height: maxRadius*2, duration: duration),
                            .run {
                                explosionCircle.removeFromParent()
                            }
                        ])
                    )
                    
//                    var currentRadius: CGFloat = 10
//                    explosion.run(.sequence([
//                        .customAction(withDuration: duration) { (node, elapsedTime) in
//
//                            let percent = elapsedTime / CGFloat(duration)
//                            var newRadius: CGFloat?
//
//                            if percent < 0.25 {
//                                let radius = maxRadius * 0.25
//                                guard currentRadius < radius else { return }
//                                newRadius = radius
//                            } else if percent < 0.50 {
//                                let radius = maxRadius * 0.50
//                                guard currentRadius < radius else { return }
//                                newRadius = radius
//                            } else if percent < 0.75 {
//                                let radius = maxRadius * 0.75
//                                guard currentRadius < radius else { return }
//                                newRadius = radius
//                            } else {
//                                let radius = maxRadius
//                                guard currentRadius < radius else { return }
//                                newRadius = radius
//                            }
//
//                            if let radius = newRadius {
//                                currentRadius = radius
//                                explosionCircle.removeFromParent()
//                                explosionCircle = self.makeExplosion(withRadius: radius)
//                                explosionCircle.position = node.position
//                                tree.addChild(explosionCircle)
//                            }
//
//                        },
//                        .run {
//                            explosionCircle.removeFromParent()
//                        }
//                    ]))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        explosion.removeFromParent()
                    }
                }
                
            } else {
                return
            }
            
            firstNode.removeFromParent()
            
        }
    }
    
}
