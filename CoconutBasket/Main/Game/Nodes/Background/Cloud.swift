//
//  Cloud.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 26/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import SpriteKit

class Cloud: GameNode {
    
    enum CloudType {
        
        case regular
        case wide
        case tall
        
        init(_ type: Int) {
            switch type {
            case 0: self = .regular
            case 1: self = .wide
            case 2: self = .tall
            default:
                self = .regular
            }
        }
        
        var imageName: String {
            switch self {
            case .regular:
                return "cloud_regular"
            case .wide:
                return "cloud_wide"
            case .tall:
                return "cloud_tall"
            }
        }
    }
    
    private(set) var type: CloudType = .regular
    private(set) var cloudSpeed: TimeInterval = 0
    
    static func newInstance() -> Cloud {
        
        let cloudType = CloudType(Int.random(in: 0...2))
        
        let newCloud = Cloud(imageNamed: cloudType.imageName)
        newCloud.type = cloudType
        newCloud.zPosition = 2
        
        let maxSpeed: TimeInterval = 100
        let textureSize = newCloud.texture!.size()
        let minHeight = textureSize.height-100
        let maxHeight = textureSize.height
        
        let ratio = textureSize.width / textureSize.height
        let newHeight = CGFloat.random(in: minHeight...maxHeight)
        newCloud.size = CGSize(width: newHeight * ratio, height: newHeight)
        
        var speed = TimeInterval((newHeight / maxHeight).constrained(min: 0, max: 1)) * maxSpeed
        // Get inversed value of speed because the smaller the cloud the slower it should go
        speed = maxSpeed - speed
        
        newCloud.cloudSpeed = speed
        newCloud.nodeSpeed = speed
        
        return newCloud
    }
    
}
