//
//  GameScene.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 06/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import FoundationExtended

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var floorMargin: CGFloat = 50
    
    private var lastUpdateTime: TimeInterval = 0
    
    private var isPlayerMoving = false
    private var accumulatedDeltaTime: TimeInterval = 0
    
    private var backgroundManager: BackgroundManager!
    
    private var collisionDetectionManager: CollisionDetectionManager {
        return (Env.collisionEventsDispatcher as? CollisionDetectionManager).require("")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        Env.gameState.yOffset = ((size.height - 768) / 2).constrained(min: 0)
        Env.gameState.scaleFactor = size.height / 768
        
        floorMargin *= Env.gameState.scaleFactor
        
        backgroundColor = UIColor(hex: 0xCFEFFC)
        backgroundManager = BackgroundManager(gameScene: self)
        collisionDetectionManager.gameScene = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = collisionDetectionManager
        backgroundManager.gameSceneDidLoad()
        
        player = Player.newInstance()
        player.position = CGPoint(x: frame.width/2, y: floorMargin + (player.size.height/2))
        addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Initialize _lastUpdateTime if it has not already been
        if lastUpdateTime == 0 {
          lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - lastUpdateTime
        
        player.update(deltaTime: dt)
        
        if isPlayerMoving {
            
            accumulatedDeltaTime += dt
            
            if accumulatedDeltaTime >= Env.gameState.speed {
                
                accumulatedDeltaTime = 0
                isPlayerMoving = false
                backgroundManager.playerDidStopMoving()
            }
        }
        
        backgroundManager.update(deltaTime: dt)
        
        lastUpdateTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isPlayerMoving == false else { return }
        
        let touchLocation = touches.first!.location(in: view)
        
        isPlayerMoving = true
        
        if touchLocation.y > frame.height/2 {
            player.startAction(.running)
        } else {
            player.startAction(.jumping)
        }
        
        // Start moving the background
        backgroundManager.playerDidStartMoving()
    }
    
}
