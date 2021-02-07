//
//  GameNode.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 19/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import FoundationExtended
import SpriteKit

@objc protocol GameNode {
    
    var isMoving: Bool { get }
    
    func update(deltaTime: TimeInterval)
    func move(by dx: CGFloat)
}

// @NonFinal
class GameSpriteNode: SKSpriteNode {
    
    private(set) var isMoving = false
    private var amountMoved: CGFloat = 0
    private var amountToMove: CGFloat = 0
    private var accumulatedDeltaTime: TimeInterval = 0
    
}

extension GameSpriteNode: GameNode {
    
    func update(deltaTime: TimeInterval) {
        
        if isMoving {
            
            accumulatedDeltaTime += deltaTime
            
            let percent = (accumulatedDeltaTime / Env.gameState.speed).constrained(min: 0, max: 1)
            let shouldMoveBy = (amountToMove * CGFloat(percent)) - amountMoved
            
            position.x += shouldMoveBy
            amountMoved += shouldMoveBy
            
            if percent >= 1 {
                isMoving = false
            }
        }
        
    }
    
    func move(by dx: CGFloat) {
        
        guard isMoving == false else { return }
        
        isMoving = true
        
        accumulatedDeltaTime = 0
        amountMoved = 0
        amountToMove = dx
    }
    
}

final class GameWrapperNode: SKNode {
    
    private(set) var isMoving = false
    private var amountMoved: CGFloat = 0
    private var amountToMove: CGFloat = 0
    private var accumulatedDeltaTime: TimeInterval = 0
    
}

extension GameWrapperNode: GameNode {
    
    func update(deltaTime: TimeInterval) {
        
        if isMoving {
            
            accumulatedDeltaTime += deltaTime
            
            let percent = (accumulatedDeltaTime / Env.gameState.speed).constrained(min: 0, max: 1)
            let shouldMoveBy = (amountToMove * CGFloat(percent)) - amountMoved
            
            position.x += shouldMoveBy
            amountMoved += shouldMoveBy
            
            if percent >= 1 {
                isMoving = false
            }
        }
        
    }
    
    func move(by dx: CGFloat) {
        
        guard isMoving == false else { return }
        
        isMoving = true
        
        accumulatedDeltaTime = 0
        amountMoved = 0
        amountToMove = dx
    }
    
}
