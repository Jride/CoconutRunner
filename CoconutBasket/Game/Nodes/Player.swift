//
//  Player.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 09/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    private static let prefix = "character_malePerson_"
    
    static func newInstance() -> Player {
        let newPlayer = Player(imageNamed: "\(prefix)idle")
        newPlayer.setup()
        return newPlayer
    }
    
    struct PlayerTextures {
        let idle = SKTexture(imageNamed: "\(prefix)idle")
        let jump = SKTexture(imageNamed: "\(prefix)jump")
        let fall = SKTexture(imageNamed: "\(prefix)fall")
        let hit = SKTexture(imageNamed: "\(prefix)hit")
    }
    
    enum Action {
        case idle
        case running
        case jumping
        case hit
    }
    
    enum Movement {
        case idle
        case jumping
    }
    
    struct PlayerAction {
        
        var action: Action = .idle
        var accumulatedTime: TimeInterval = 0
        
        var isMoving: Bool {
            return action != .idle
        }
    }
    
    private var playerAction = PlayerAction()
    private var movement: Movement = .idle
    private var previousAction: Action?
    private var playerTextures = PlayerTextures()
    private var runningAction: SKAction!
    private let hitAnimationDuration: TimeInterval = 0.3
    private let jumpHeight: CGFloat = 100
    
    private var originalPosition: CGPoint!
    
    private var accumulatedDeltaTime: TimeInterval = 0
    
    struct AnimationKeys {
        static let running = "PlayerRunning"
    }
    
    private func setPlayerAction(_ action: Action) {
        
        previousAction = playerAction.action
        playerAction.action = action
        playerAction.accumulatedTime = 0
        
        removeAction(forKey: AnimationKeys.running)
        
        switch action {
            
        case .idle:
            if let originalPos = originalPosition {
                position = originalPos
            }
            texture = playerTextures.idle
            
        case .jumping:
            let overallPct = (accumulatedDeltaTime / GameState.shared.speed).constrained(min: 0, max: 1)
            if overallPct < 0.5 {
                texture = playerTextures.jump
            } else {
                texture = playerTextures.fall
            }
            
        case .running:
            run(.repeatForever(runningAction), withKey: AnimationKeys.running)
            
        case .hit:
            texture = playerTextures.hit
        }
        
    }
    
    func update(deltaTime: TimeInterval) {
        
        guard playerAction.isMoving else { return }
        
        accumulatedDeltaTime += deltaTime
        
        if accumulatedDeltaTime >= GameState.shared.speed {
            accumulatedDeltaTime = 0
            setPlayerAction(.idle)
            movement = .idle
        } else {
            
            playerAction.accumulatedTime += deltaTime
            
            switch playerAction.action {
            
            case .jumping:
                let overallPct = (accumulatedDeltaTime / GameState.shared.speed).constrained(min: 0, max: 1)
                if overallPct < 0.5 {
                    texture = playerTextures.jump
                } else {
                    texture = playerTextures.fall
                }
            
            case .hit:
                if playerAction.accumulatedTime > hitAnimationDuration {
                    if let prevAction = previousAction {
                        setPlayerAction(prevAction)
                    }
                }
                
            default:
                break
            }
            
            switch movement {
            case .idle:
                break
            case .jumping:
                let overallPct = (accumulatedDeltaTime / GameState.shared.speed).constrained(min: 0, max: 1)
                if overallPct <= 0.5 {
                    // upwards
                    let pct = (overallPct / 0.5).constrained(min: 0, max: 1)
                    let moveYposBy = jumpHeight * CGFloat(pct)
                    position.y = originalPosition!.y + moveYposBy
                } else {
                    // downwards
                    let pct = ((overallPct-0.5) / 0.5).constrained(min: 0, max: 1)
                    let moveYposBy = jumpHeight * CGFloat(pct)
                    position.y = originalPosition!.y + jumpHeight - moveYposBy
                }
            }
        }
    }
    
    func setup() {
        
        // Setup running action
        var runningTextures = [SKTexture]()
        for i in 0...2 {
            runningTextures.append(.init(imageNamed: "\(Self.prefix)run\(i)"))
        }
        runningAction = .animate(with: runningTextures, timePerFrame: 0.1)
        
        name = "player"
        zPosition = 1
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width-23,
                                                        height: size.height-33),
                                    center: CGPoint(x: 0, y: -18))
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        
        physicsBody?.collisionBitMask =
            CollisionType.coconut.rawValue |
            CollisionType.bomb.rawValue
        
        physicsBody?.contactTestBitMask =
            CollisionType.coconut.rawValue |
            CollisionType.bomb.rawValue |
            CollisionType.explosionRadius.rawValue
        
        physicsBody?.isDynamic = false
    }
    
    func hit() {
        
        run(.sequence([
            .colorize(with: .red, colorBlendFactor: 0.3, duration: hitAnimationDuration),
            .colorize(withColorBlendFactor: 0, duration: hitAnimationDuration)
        ]))
        
        setPlayerAction(.hit)
    }
    
    func startAction(_ action: Action) {
        guard playerAction.isMoving == false else { return }
        originalPosition = position
        
        switch action {
        case .jumping:
            movement = .jumping
        case .idle, .hit, .running:
            break
        }
        
        setPlayerAction(action)
    }
}
