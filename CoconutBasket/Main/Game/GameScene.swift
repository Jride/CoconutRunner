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
    private var lastTimePaused: TimeInterval = 0
    private var wasPaused = false
    private var gameStarted = false
    
    private var isPlayerMoving = false
    private var accumulatedDeltaTime: TimeInterval = 0
    
    private var backgroundManager: BackgroundManager!
    private var gameOverContainer: SKNode?
    private var collisionDetectionManager: CollisionDetectionManager {
        return (Env.collisionEventsDispatcher as? CollisionDetectionManager).require("")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        Env.gameState.scaleFactor = size.height / 768
        Env.gameLogic.gameScene = self
        
        player = Player.newInstance()
        
        floorMargin *= Env.gameState.scaleFactor
        
        backgroundColor = UIColor(hex: 0xCFEFFC)
        backgroundManager = BackgroundManager(gameScene: self)
        collisionDetectionManager.gameScene = self
        
        player.add(observer: backgroundManager, dispatchBehaviour: .onQueue(.main))
        Env.gameLogic.add(observer: self, dispatchBehaviour: .onQueue(.main))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = collisionDetectionManager
        backgroundManager.gameSceneDidLoad()
        Env.gameLogic.gameSceneDidLoad()
        
        player.position = CGPoint(x: frame.width/2, y: floorMargin + (player.size.height/2))
        addChild(player)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            Env.gameLogic.startGame()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        guard gameStarted else { return }
        
        // Initialize _lastUpdateTime if it has not already been
        if lastUpdateTime == 0 {
          lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt: TimeInterval
        if wasPaused {
            dt = 0
            wasPaused = false
        } else {
            dt = currentTime - lastUpdateTime
        }
        
        Env.gameLogic.update(deltaTime: dt)
        player.update(deltaTime: dt)
        
        if isPlayerMoving {
            
            accumulatedDeltaTime += dt
            
            if accumulatedDeltaTime >= Env.gameState.speed {
                
                accumulatedDeltaTime = 0
                isPlayerMoving = false
            }
        }
        
        backgroundManager.update(deltaTime: dt)
        
        lastUpdateTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchLocation = touches.first!.location(in: self)
        
        if Env.gameState.isPlayerAlive {
            
            guard isPlayerMoving == false else { return }
            
            isPlayerMoving = true
            
            if touchLocation.y < frame.height/2 {
                player.startAction(.running)
            } else {
                player.startAction(.jumping)
            }
            
        } else {
            
            if self.nodes(at: touchLocation).contains(where: { $0.name == "PlayAgain" }) {
                // User Tapped Play Again
                print("Play Again")
                Env.gameLogic.startGame()
                gameOverContainer?.removeFromParent()
            }
            
        }
        
    }
    
}

extension GameScene: GameLogicEventsDispatcherObserver {
    
    func startLevel(withConfig config: LevelConfiguration) {
        gameStarted = true
    }
    
    func gamePaused() {
        view?.isPaused = true
        lastTimePaused = lastUpdateTime
        wasPaused = true
    }
    
    func gameResumed() {
        view?.isPaused = false
    }
    
    func gameOver() {
        
        gameOverContainer = SKNode()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        var textureSize = gameOver.texture!.size()
        var ratio = textureSize.height / textureSize.width
        var newWidth: CGFloat = 650 * Env.gameState.scaleFactor
        gameOver.size = CGSize(width: newWidth, height: newWidth * ratio)
        gameOver.zPosition = ZPosition.gameOverLabel
        
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY + (100 * Env.gameState.scaleFactor))
        gameOverContainer?.addChild(gameOver)
        
        let playAgain = SKSpriteNode(imageNamed: "playAgain")
        textureSize = playAgain.texture!.size()
        ratio = textureSize.height / textureSize.width
        newWidth = 300 * Env.gameState.scaleFactor
        playAgain.size = CGSize(width: newWidth, height: newWidth * ratio)
        playAgain.zPosition = ZPosition.gameOverLabel
        playAgain.name = "PlayAgain"
        playAgain.position = CGPoint(x: frame.midX, y: gameOver.frame.minY - (150 * Env.gameState.scaleFactor))
        gameOverContainer?.addChild(playAgain)
        
        addChild(gameOverContainer!)
    }
    
}
