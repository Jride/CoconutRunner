//
//  BackgroundManager.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 25/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import Foundation

class BackgroundManager {
    
    private var trees = [PalmTree]()
    private var backgrounds = [Background]()
    private var backgroundCloudsFront = [BackgroundCloudFront]()
    private var backgroundCloudsBack = [BackgroundCloudBack]()
    private var clouds = [Cloud]()
    
    private let treePadding: CGFloat = 10
    private let treeMarginToPlayer: CGFloat = 80
    private var accumulatedDeltaTime: TimeInterval = 0
    private var timeToAddCloud: TimeInterval = 0
    
    private var gameNodes: [GameNode] {
        return [
            trees.map { $0 as GameNode },
            backgrounds.map { $0 as GameNode },
            clouds.map { $0 as GameNode }
        ].reduce([], +)
    }
    
    private var floorMargin: CGFloat { gameScene.floorMargin }
    private var frame: CGRect { gameScene.frame }
    private var size: CGSize { gameScene.size }
    
    private lazy var treeSize: CGSize = {
        let originalSize = PalmTree.originalSize
        let ratio = originalSize.width / originalSize.height
        let newHeight = originalSize.height + 100
        
        return CGSize(width: newHeight * ratio, height: newHeight)
    }()
    
    private lazy var backgroundSize: CGSize = {
        let originalSize = Background.originalSize
        let ratio = originalSize.width / originalSize.height
        let newHeight = size.height
        
        return CGSize(width: newHeight * ratio, height: newHeight)
    }()
    
    private let gameScene: GameScene
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        for _ in 0...10 {
            let cloud = Cloud.newInstance()
            cloud.position = CGPoint(x: frame.maxX + 200, y: frame.midY)
            gameScene.addChild(cloud)
            clouds.append(cloud)
        }
    }
    
    private func addCloudToSceneIfNecessary() {
        
        guard
            let cloud = clouds.first(where: { $0.isMoving == false && gameScene.intersects($0) == false }),
            accumulatedDeltaTime > timeToAddCloud
            else { return }
        
        timeToAddCloud += .random(in: 5...10)
        
        let minY = frame.midY + (cloud.size.height/2) + 40
        let maxY = frame.maxY - (cloud.size.height/2) - 20
        
        cloud.position = CGPoint(x: frame.maxX + 100, y: .random(in: minY...maxY))
        
        cloud.move(by: -(frame.width + 200))
    }
    
    private func setupBackground() {
        
        var currentX: CGFloat = frame.minX + backgroundSize.width / 2
        
        let numBackgroundsNeeded = Int((frame.width / backgroundSize.width).rounded(.up)) + 1
        for _ in 0..<numBackgroundsNeeded {
            
            let bg = Background(size: backgroundSize)
            bg.position = CGPoint(x: currentX, y: frame.midY)
            
            let bgCloudFront = BackgroundCloudFront(size: backgroundSize)
            bgCloudFront.position = CGPoint(x: currentX, y: frame.midY + 80)
            bgCloudFront.isAnimating = true
            
            let bgCloudBack = BackgroundCloudBack(size: backgroundSize)
            bgCloudBack.position = CGPoint(x: currentX, y: frame.midY + 100)
            bgCloudBack.isAnimating = true
            
            currentX += backgroundSize.width
            gameScene.addChild(bg)
            gameScene.addChild(bgCloudFront)
            gameScene.addChild(bgCloudBack)
            
            backgrounds.append(bg)
            backgroundCloudsFront.append(bgCloudFront)
            backgroundCloudsBack.append(bgCloudBack)
        }
    }
    
    private func setupPalmTrees() {
        
        let offset = (treeSize.width / 2) + 22 + treePadding
        var currentX: CGFloat = frame.midX - offset - treeSize.width - treePadding
        
        let numTreesNeeded = Int((frame.width / treeSize.width).rounded(.up)) + 1
        for _ in 0..<numTreesNeeded {
            let tree = PalmTree(size: treeSize)
            tree.position = CGPoint(x: currentX, y: frame.midY - treeMarginToPlayer)
            tree.zPosition = -1
            currentX += tree.size.width + treePadding
            gameScene.addChild(tree)
            
            trees.append(tree)
        }
    }
    
    private func setupFloor() {
        
        let floor = SKShapeNode(rectOf: CGSize(width: size.width, height: floorMargin))
        floor.position = CGPoint(x: frame.midX, y: frame.minY + floorMargin/2)
        floor.zPosition = -1
        floor.alpha = 0
        gameScene.addChild(floor)
        
        floor.name = "floor"
        floor.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width/2, y: floorMargin/2),
                                          to: CGPoint(x: size.width, y: floorMargin/2))
        floor.physicsBody?.categoryBitMask = CollisionType.floor.rawValue
        floor.physicsBody?.collisionBitMask = CollisionType.coconut.rawValue
        floor.physicsBody?.contactTestBitMask = CollisionType.coconut.rawValue
        floor.physicsBody?.isDynamic = false
    }
    
    private func recycleGameObjectsIfNecessary() {
        
        if let firstTree = trees.first,
            gameScene.intersects(firstTree) == false,
            let removedTree = trees.popFirst(),
            let lastTree = trees.last {
            
            removedTree.position.x = lastTree.position.x + treeSize.width + treePadding
            trees.append(removedTree)
        }
        
        if let firstBg = backgrounds.first,
            gameScene.intersects(firstBg) == false,
            let removedBg = backgrounds.popFirst(),
            let lastBg = backgrounds.last {
            
            removedBg.position.x = lastBg.position.x + backgroundSize.width
            backgrounds.append(removedBg)
        }
        
        let multiplyer = CGFloat(backgroundCloudsFront.count) - 1
        var amountToMoveCloudBackground = backgroundSize.width * multiplyer
        amountToMoveCloudBackground += 5 * multiplyer
        
        if let firstBgCloudFront = backgroundCloudsFront.first,
            gameScene.intersects(firstBgCloudFront) == false,
            let removedBg = backgroundCloudsFront.popFirst(),
            let lastBg = backgroundCloudsFront.last {
            
            removedBg.position.x = lastBg.position.x + backgroundSize.width
            backgroundCloudsFront.append(removedBg)
        }
        
        if let firstBgCloudBack = backgroundCloudsBack.first,
            gameScene.intersects(firstBgCloudBack) == false,
            let removedBg = backgroundCloudsBack.popFirst(),
            let lastBg = backgroundCloudsBack.last {
            
            removedBg.position.x = lastBg.position.x + backgroundSize.width
            backgroundCloudsBack.append(removedBg)
        }
    }
    
    @objc private func knockDownCoconut() {
        let visibleTrees = trees.filter { gameScene.intersects($0) }
        let randomIndex: Int = Int.random(in: 1..<visibleTrees.count-1)
        if let tree = visibleTrees[maybe: randomIndex] {
            tree.knockRandChild()
        }
    }
    
}

// MARK: - Public
extension BackgroundManager {
    
    func gameSceneDidLoad() {
        
        setupBackground()
        setupPalmTrees()
        setupFloor()
        
        let sequence = SKAction.sequence([
            .wait(forDuration: 0.7),
            .perform(#selector(knockDownCoconut), onTarget: self)
        ])
        
        gameScene.run(.repeatForever(sequence), withKey: "knockCoconuts")
    }
    
    func update(deltaTime: TimeInterval) {
        
        accumulatedDeltaTime += deltaTime
        
        gameNodes.forEach { $0.update(deltaTime: deltaTime) }
        backgroundCloudsFront.forEach { $0.update(deltaTime: deltaTime) }
        backgroundCloudsBack.forEach { $0.update(deltaTime: deltaTime) }
        
//        addCloudToSceneIfNecessary()
        recycleGameObjectsIfNecessary()
    }
    
    func playerDidStartMoving() {
        clouds.forEach { $0.nodeSpeed = ($0.nodeSpeed - 2).constrained(min: 3) }
        trees.forEach { $0.move(by: -(treeSize.width + treePadding)) }
        backgrounds.forEach { $0.move(by: -(backgroundSize.width/10)) }
    }
    
    func playerDidStopMoving() {
        clouds.forEach { $0.nodeSpeed = $0.cloudSpeed }
    }
}
