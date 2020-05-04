//
//  GameNode.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 19/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import FoundationExtended
import SpriteKit

class GameNode: SKSpriteNode {
    
    private(set) var isMoving = false
    private var amountMoved: CGFloat = 0
    private var amountToMove: CGFloat = 0
    private var originalAccumulatedDeltaTime: TimeInterval = 0
    private var accumulatedDeltaTime: TimeInterval = 0
    
    private var _speed: TimeInterval = GameState.shared.speed
    var nodeSpeed: TimeInterval {
        set {
            if isMoving {
                
                if newValue > _speed {
                    // Slow Down
                    let percent = (originalAccumulatedDeltaTime / _speed).constrained(min: 0, max: 1)
                    let slowDownBy = (newValue - _speed) * percent
                    _speed = (_speed - (_speed * percent) + slowDownBy).constrained(min: 0)
                } else {
                    // Speed Up
                    let percent = (accumulatedDeltaTime / _speed).constrained(min: 0, max: 1)
                    let speedUpBy = (_speed - newValue) * percent
                    _speed = (_speed - (_speed * percent) - speedUpBy).constrained(min: 0)
                }
                
                let negativeOrPositive: CGFloat = amountToMove < 0 ? -1 : 1
                amountToMove = (amountToMove.abs - amountMoved.abs) * negativeOrPositive
                amountMoved = 0
                accumulatedDeltaTime = 0
            } else {
                _speed = newValue
            }
        } get {
            _speed
        }
    }
    
    func update(deltaTime: TimeInterval) {
        
        if isMoving {
            
            originalAccumulatedDeltaTime += deltaTime
            accumulatedDeltaTime += deltaTime
            
            let percent = (accumulatedDeltaTime / nodeSpeed).constrained(min: 0, max: 1)
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
        
        originalAccumulatedDeltaTime = 0
        accumulatedDeltaTime = 0
        amountMoved = 0
        amountToMove = dx
    }
    
    func cancelMovement() {
        isMoving = false
        amountMoved = 0
        originalAccumulatedDeltaTime = 0
        accumulatedDeltaTime = 0
        amountToMove = 0
    }
    
}
