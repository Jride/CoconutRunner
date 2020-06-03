//
//  CollisionDetectionManager.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 03/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import FoundationExtended

class CollisionDetectionManager: NSObject, SKPhysicsContactDelegate, CollisionEventsDispatcher, Observable {
    
    var observerStore = ObserverStore<CollisionEventsDispatcherObserver>()
    var gameScene: GameScene!
    
    private var isPlayerAlive: Bool { return Env.gameState.isPlayerAlive }
    
    private var gameState: GameState {
        return Env.gameState
    }
    
    private func makeExplosion(withRadius radius: CGFloat) -> SKNode {
        
        let explosionCircle = SKNode()
        
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
            
            // Non-damaging collisions
            
            if let banana = firstNode as? Banana, let tree = banana.palmTree {
                
                let bananaCollection = SKEmitterNode(fileNamed: "BananaCollection").require("")
                bananaCollection.position = firstNode.position
                bananaCollection.zPosition = ZPosition.explosions
                tree.addChild(bananaCollection)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    bananaCollection.removeFromParent()
                }
                
                firstNode.removeFromParent()
                
                // TODO: Add game logic for collecting a banana
                
            }
            
            // Damaging collisions
            
            // If the player is in mid-hit then ignore this second hit
            guard gameScene.player.playerAction.action != .hit else {
                firstNode.removeFromParent()
                return
            }
            
            if let coconut = firstNode as? Coconut, let tree = coconut.palmTree {
                
                let explosion = SKEmitterNode(fileNamed: "CoconutExplosion").require("")
                explosion.position = firstNode.position
                explosion.zPosition = ZPosition.explosions
                tree.addChild(explosion)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    explosion.removeFromParent()
                }
                
                observerStore.forEach { $0.playerWasHitByEnemy(.coconut(coconut)) }
                
            } else if let bomb = firstNode as? Bomb, let tree = bomb.palmTree {
                
                let explosion = SKEmitterNode(fileNamed: "Explosion").require("")
                explosion.position = firstNode.position
                explosion.zPosition = ZPosition.explosions
                tree.addChild(explosion)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    explosion.removeFromParent()
                }
                
                observerStore.forEach { $0.playerWasHitByEnemy(.bomb(bomb)) }
                
            } else if firstNode.name == "explosionRadius" {
                
                observerStore.forEach { $0.playerWasHitByEnemy(.explosion(firstNode)) }
                
            } else {
                
                // Collided with an unknown object
                return
            }
            
            firstNode.removeFromParent()
            
        } else if secondNode.name == "floor" {
            
            if let coconut = firstNode as? Coconut, let tree = coconut.palmTree {
                
                let explosion = SKEmitterNode(fileNamed: "CoconutExplosionUp").require("")
                explosion.position = firstNode.position
                explosion.zPosition = ZPosition.explosions
                tree.addChild(explosion)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    explosion.removeFromParent()
                }
                
                observerStore.forEach { $0.enemyCollidedWithFloor(.coconut(coconut)) }
                
            } else if let bomb = firstNode as? Bomb, let tree = bomb.palmTree {
                
                let explosion = SKEmitterNode(fileNamed: "ExplosionUp").require("")
                explosion.position = firstNode.position
                explosion.zPosition = ZPosition.explosions
                tree.addChild(explosion)
                
                let duration = TimeInterval(explosion.particleLifetime) / 2
                let maxRadius: CGFloat = 55 * Env.gameState.scaleFactor
                
                let explosionCircle = makeExplosion(withRadius: 10)
                explosionCircle.position = firstNode.position
                tree.addChild(explosionCircle)
                
                explosionCircle.run(
                    .sequence([
                        .scale(to: ((maxRadius*2) / 10), duration: duration),
                        .run {
                            explosionCircle.removeFromParent()
                        }
                    ])
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    explosion.removeFromParent()
                }
                
                observerStore.forEach { $0.enemyCollidedWithFloor(.bomb(bomb)) }
                
            } else {
                return
            }
            
            firstNode.removeFromParent()
            
        }
    }
    
}
