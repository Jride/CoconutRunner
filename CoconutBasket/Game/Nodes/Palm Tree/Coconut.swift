//
//  Coconut.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 13/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class Coconut: SKSpriteNode {
    
    static func size() -> CGSize {
        let textureSize = SKTexture(imageNamed: "coconut").size()
        let ratio = textureSize.width / textureSize.height
        let newHeight: CGFloat = 55 * GameState.shared.scaleFactor
        return CGSize(width: newHeight * ratio, height: newHeight)
    }
    
    static func newInstance() -> Coconut {
        
        let newCoconut = Coconut(imageNamed: "coconut")
        
        newCoconut.size = Self.size()
        newCoconut.color = UIColor(red: 150/255, green: 90/255, blue: 62/255, alpha: 1)
        newCoconut.colorBlendFactor = 0.8
        newCoconut.zPosition = 1
        
        return newCoconut
    }
    
    var palmTree: PalmTree?
}
