//
//  Player.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 09/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

protocol PlayerEventsDispatcherObserver: class {
    func playerDidStartMoving()
    func playerDidStopMoving()
}

extension PlayerEventsDispatcherObserver {
    func playerDidStartMoving() {}
    func playerDidStopMoving() {}
}

protocol PlayerEventsDispatcher {
    func add(observer: PlayerEventsDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: PlayerEventsDispatcherObserver)
}

class Player: SKSpriteNode, PlayerEventsDispatcher, Observable {
    
    var observerStore = ObserverStore<PlayerEventsDispatcherObserver>()
    private static let prefix = "character_malePerson_"
    
    static func newInstance() -> Player {
        let newPlayer = Player(imageNamed: "\(prefix)idle")
        
        let textureSize = newPlayer.texture!.size()
        let ratio = textureSize.width / textureSize.height
        let newHeight: CGFloat = 128 * Env.gameState.scaleFactor
        
        newPlayer.size = CGSize(width: newHeight * ratio, height: newHeight)
        newPlayer.zPosition = ZPosition.player
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
    }
    
    private(set) var playerAction = PlayerAction()
    private var movement: Movement = .idle
    private var previousAction: Action?
    private var playerTextures = PlayerTextures()
    private var runningAction: SKAction!
    private let hitAnimationDuration: TimeInterval = 0.3
    private var jumpHeight: CGFloat { 120 * Env.gameState.scaleFactor }
    
    private var _isMoving = false {
        didSet {
            if isMoving {
                observerStore.forEach { $0.playerDidStartMoving() }
            } else {
                observerStore.forEach { $0.playerDidStopMoving() }
            }
        }
    }
    private(set) var isMoving: Bool {
        get { return _isMoving }
        set {
            if _isMoving != newValue {
                _isMoving = newValue
            }
        }
    }
    
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
            let overallPct = (accumulatedDeltaTime / Env.gameState.speed).constrained(min: 0, max: 1)
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
    
    private func animateHitSequence() {
        
        run(.sequence([
            .colorize(with: .red, colorBlendFactor: 0.3, duration: hitAnimationDuration),
            .colorize(withColorBlendFactor: 0, duration: hitAnimationDuration)
        ]))
        
        setPlayerAction(.hit)
    }
    
    private func setup() {
        
        Env.collisionEventsDispatcher.add(observer: self, dispatchBehaviour: .onQueue(.main))
        
        // Setup running action
        var runningTextures = [SKTexture]()
        for i in 0...2 {
            runningTextures.append(.init(imageNamed: "\(Self.prefix)run\(i)"))
        }
        runningAction = .animate(with: runningTextures, timePerFrame: 0.1)
        
        name = "player"
        zPosition = ZPosition.player
        
        let centerY = Env.gameState.scaleFactor * 18
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - (23 * Env.gameState.scaleFactor),
                                                        height: size.height - (33 * Env.gameState.scaleFactor)),
                                    center: CGPoint(x: 0, y: -centerY))
        
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
    
    func update(deltaTime: TimeInterval) {
        
        accumulatedDeltaTime += deltaTime
        
        if accumulatedDeltaTime >= Env.gameState.speed {
            accumulatedDeltaTime = 0
            setPlayerAction(.idle)
            movement = .idle
            isMoving = false
        } else {
            
            playerAction.accumulatedTime += deltaTime
            
            switch playerAction.action {
            
            case .jumping:
                let overallPct = (accumulatedDeltaTime / Env.gameState.speed).constrained(min: 0, max: 1)
                if overallPct < 0.5 {
                    texture = playerTextures.jump
                } else {
                    texture = playerTextures.fall
                }
            
            case .hit:
                if playerAction.accumulatedTime > hitAnimationDuration {
                    if isMoving {
                        guard let prevAction = previousAction else { return }
                        setPlayerAction(prevAction)
                    } else {
                        setPlayerAction(.idle)
                    }
                }
                
            default:
                break
            }
            
            switch movement {
            case .idle:
                break
            case .jumping:
                let overallPct = (accumulatedDeltaTime / Env.gameState.speed).constrained(min: 0, max: 1)
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
    
    func startAction(_ action: Action) {
        
        guard isMoving == false else { return }
        isMoving = true
        
        accumulatedDeltaTime = 0
        originalPosition = position
        
        switch action {
        case .jumping:
            movement = .jumping
        case .idle, .hit, .running:
            break
        }
        
        // If we started running or jumping mid hit then we need to update the
        // previous player action
        if playerAction.action == .hit {
            previousAction = action
        }
        
        setPlayerAction(action)
    }
}

extension Player: CollisionEventsDispatcherObserver {
    
    func playerWasHitByEnemy(_ enemy: Enemy) {
        animateHitSequence()
    }
    
}
