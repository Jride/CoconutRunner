//
//  BackgroundManager.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 25/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import Foundation

final class BackgroundManager {
    
    private var treesContainer: GameWrapperNode?
    private var trees = [PalmTree]()
    
    private var backgroundsContainer: GameWrapperNode?
    private var backgrounds = [Background]()
    
    private var backgroundCloudsFrontContainer: ContinuousMovingNode?
    private var backgroundCloudsFront = [BackgroundCloudFront]()
    
    private var backgroundCloudsBackContainer: ContinuousMovingNode?
    private var backgroundCloudsBack = [BackgroundCloudBack]()
    
    private var treePadding: CGFloat = 10
    private var treeMarginToPlayer: CGFloat = 80
    private var timeToAddCloud: TimeInterval = 0
    
    private var floorMargin: CGFloat { gameScene.floorMargin }
    private var frame: CGRect { gameScene.frame }
    private var size: CGSize { gameScene.size }
    
    private lazy var treeSize: CGSize = {
        let originalSize = PalmTree.originalSize
        let ratio = originalSize.width / originalSize.height
        let newHeight = 338 * Env.gameState.scaleFactor
        
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
        
        treePadding *= Env.gameState.scaleFactor
        treeMarginToPlayer *= Env.gameState.scaleFactor
        
        Env.gameLogic.add(observer: self, dispatchBehaviour: .onQueue(.main))
    }
    
    // MARK: - Add Background
    private func setupBackground() {
        
        let bgContainer = GameWrapperNode()
        backgroundsContainer?.removeFromParent()
        backgrounds.removeAll()
        
        let bgCloudsFrontContainer = ContinuousMovingNode(movementSpeed: 30)
        backgroundCloudsFrontContainer?.removeFromParent()
        backgroundCloudsFront.removeAll()
        
        let bgCloudsBackContainer = ContinuousMovingNode(movementSpeed: 10)
        backgroundCloudsBackContainer?.removeFromParent()
        backgroundCloudsBack.removeAll()
        
        var currentX: CGFloat = backgroundSize.width / 2
        
        let numBackgroundsNeeded = Int((frame.width / backgroundSize.width).rounded(.up)) + 1
        for _ in 0..<numBackgroundsNeeded {
            
            let bg = Background(size: backgroundSize)
            bg.position = CGPoint(x: currentX, y: frame.height/2)
            
            let bgCloudFront = BackgroundCloudFront(size: backgroundSize)
            bgCloudFront.position = CGPoint(x: currentX, y: frame.height/2 + 80)
            
            let bgCloudBack = BackgroundCloudBack(size: backgroundSize)
            bgCloudBack.position = CGPoint(x: currentX, y: frame.height/2 + 100)
            
            currentX += backgroundSize.width
            bgContainer.addChild(bg)
            bgCloudsFrontContainer.addChild(bgCloudFront)
            bgCloudsBackContainer.addChild(bgCloudBack)
            
            backgrounds.append(bg)
            backgroundCloudsFront.append(bgCloudFront)
            backgroundCloudsBack.append(bgCloudBack)
        }
        
        backgroundsContainer = bgContainer
        backgroundCloudsFrontContainer = bgCloudsFrontContainer
        backgroundCloudsBackContainer = bgCloudsBackContainer
        
        gameScene.addChild(bgContainer)
        gameScene.addChild(bgCloudsFrontContainer)
        gameScene.addChild(bgCloudsBackContainer)
    }
    
    // MARK: - Add Palm Trees
    private func setupPalmTrees() {
        
        treesContainer?.removeFromParent()
        trees.removeAll()
        
        let container = GameWrapperNode()
        
        let offset = (treeSize.width / 2) + 22 + treePadding
        var currentX: CGFloat = frame.width/2 - offset - treeSize.width - treePadding
        
        let numTreesNeeded = Int((frame.width / treeSize.width).rounded(.up)) + 1
        for _ in 0..<numTreesNeeded {
            let tree = PalmTree(size: treeSize)
            tree.position = CGPoint(x: currentX, y: frame.height/2 - treeMarginToPlayer)
            tree.zPosition = ZPosition.palmTree
            currentX += tree.size.width + treePadding
            
            container.addChild(tree)
            
            trees.append(tree)
        }
        
        treesContainer = container
        gameScene.addChild(container)
    }
    
    // MARK: - Add Floor
    private func setupFloor() {
        
        let floor = SKShapeNode(rectOf: CGSize(width: size.width, height: floorMargin))
        floor.position = CGPoint(x: frame.width/2, y: floorMargin/2)
        floor.zPosition = ZPosition.floor
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
            gameScene.intersects(firstTree.treeNode) == false,
            let removedTree = trees.popFirst(),
            let lastTree = trees.last {
            
            removedTree.position.x = lastTree.position.x + treeSize.width + treePadding
            trees.append(removedTree)
            removedTree.setupTree(isVisibleInScene: false)
        }
        
        if let firstBg = backgrounds.first,
            gameScene.intersects(firstBg) == false,
            let removedBg = backgrounds.popFirst(),
            let lastBg = backgrounds.last {
            
            removedBg.position.x = lastBg.position.x + backgroundSize.width
            backgrounds.append(removedBg)
        }
        
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
    
}

// MARK: - Public
extension BackgroundManager {
    
    func configure() {
        setupBackground()
        setupPalmTrees()
        setupFloor()
    }
    
    func resetScene() {
        trees.forEach {
            let isVisible = gameScene.intersects($0.treeNode)
            $0.setupTree(isVisibleInScene: isVisible)
        }
    }
    
    func update(deltaTime: TimeInterval) {
        
        treesContainer?.update(deltaTime: deltaTime)
        trees.forEach { $0.update(deltaTime: deltaTime) }
        
        backgroundsContainer?.update(deltaTime: deltaTime)
        backgroundCloudsFrontContainer?.update(deltaTime: deltaTime)
        backgroundCloudsBackContainer?.update(deltaTime: deltaTime)
        
        recycleGameObjectsIfNecessary()
    }
    
    func knockDownRandomCoconut() {
        let visibleTrees = trees.filter { gameScene.intersects($0.treeNode) }
        let start = Int(visibleTrees.count/2)
        let randomIndex: Int = Int.random(in: start..<visibleTrees.count)
        if let tree = visibleTrees[maybe: randomIndex] {
            tree.knockRandChild()
        }
    }
    
}

extension BackgroundManager: PlayerEventsDispatcherObserver {
    
    func playerDidStartMoving() {
        treesContainer?.move(by: -(treeSize.width + treePadding))
        backgroundsContainer?.move(by: -(backgroundSize.width/10))
    }
    
}

extension BackgroundManager: GameLogicEventsDispatcherObserver {
    
    func gameOver() {
        gameScene.removeAction(forKey: "knockCoconuts")
    }
    
    func playerIdleTimeThresholdExceeded() {
        
        let playerXPos = gameScene.player.position.x
        guard let treeInfrontOfPlayer = trees.first(where: {
            let treeXPos = gameScene.convert($0.treeNode.position, from: $0.treeNode).x
            return treeXPos > playerXPos
        }) else { return }
        
        treeInfrontOfPlayer.runMonkeyBombAnimation()
    }
    
}
