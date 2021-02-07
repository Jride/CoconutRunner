//
//  PalmTree.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 06/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit
import Foundation

final class PalmTree: SKNode {
    
    static let originalSize = SKTexture(imageNamed: "palmTree").size()
    
    var fallingChildNodes = [SKSpriteNode]()
    var monkey: Monkey?
    let treeNode: SKSpriteNode
    let size: CGSize
    
    var gameScene: GameScene? {
        return scene as? GameScene
    }
    
    private var treeChildGroup = TreeChildGroup()
    private lazy var coconutSize: CGSize = {
        return Coconut.size()
    }()
    private var scale: CGFloat {
        return Env.gameState.scaleFactor
    }
    
    init(size: CGSize) {
        self.size = size
        
        let texture = SKTexture(imageNamed: "palmTree")
        treeNode = SKSpriteNode(texture: texture, color: .white, size: size)
        treeNode.zPosition = ZPosition.palmTree
        super.init()
        
        zPosition = ZPosition.palmTree
        addChild(treeNode)
        configureCoconuts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCoconuts() {
        
        let top = makeCoconutNode(at: CGPoint(x: 0,
                                              y: coconutSize.height/2 + (35 * scale)))
        treeChildGroup.top.coconut = top
        
        let left =  makeCoconutNode(at: CGPoint(x: -15 * scale,
                                                y: coconutSize.height/2 + (15 * scale)))
        treeChildGroup.left.coconut = left
        
        let right = makeCoconutNode(at: CGPoint(x: 15 * scale,
                                                y: coconutSize.height/2 + (15 * scale)))
        treeChildGroup.right.coconut = right
        
        treeChildGroup.coconuts().forEach {
            $0.palmTree = self
            addChild($0)
        }
        treeChildGroup.setActive()
    }
    
    private func makeCoconutNode(at point: CGPoint) -> Coconut {
        
        let coconut = Coconut.newInstance()
        coconut.position = point
        coconut.palmTree = self
        
        return coconut
    }
    
    private func makeBombNode(at point: CGPoint) -> Bomb {
        
        let bomb = Bomb.newInstance()
        bomb.position = point
        bomb.palmTree = self
        
        return bomb
    }
    
    private func addMonkeyWithBomb() {
        
        let newMonkey = Monkey.newInstance()
        newMonkey.position = CGPoint(x: newMonkey.size.width/2 - (35 * scale),
                                  y: treeNode.size.height/2 - (110 * scale))
        newMonkey.palmTree = self
        addChild(newMonkey)
        self.monkey = newMonkey
    }
    
    private func addFloatingBananaNode() {
        
        guard
            let treeXPosition = gameScene?.convert(treeNode.position, from: treeNode).x,
            let playerXPos = gameScene?.player.position.x,
            treeXPosition > playerXPos else {
                return
        }
        
        let middle = CGPoint(x: 0, y: 0)
        let floor = CGPoint(x: 0, y: -160 * scale)
        
        let point = [middle, floor].randomElement()!
        
        let banana = Banana.newInstance()
        banana.position = CGPoint(x: point.x + banana.size.width/2 + (10 * scale),
                                  y: point.y - 60 * scale)
        banana.palmTree = self
        addChild(banana)
        
        let originalSize = banana.size
        
        let ratio = originalSize.width / originalSize.height
        let newHeight: CGFloat = originalSize.height * 1.3
        let scaleToSize = CGSize(width: newHeight * ratio, height: newHeight)
        
        let resize = SKAction.sequence([
            .resize(toWidth: scaleToSize.width, height: scaleToSize.height, duration: 0.5),
            .resize(toWidth: originalSize.width, height: originalSize.height, duration: 0.5)
        ])
        banana.run(.repeatForever(resize))
    }
    
    func update(deltaTime: TimeInterval) {
        guard let gameScene = gameScene else { return }
        
        monkey?.update(deltaTime: deltaTime)
        
        // Remove all the coconuts that are out of frame
        fallingChildNodes.removeAll {
            if gameScene.intersects($0) == false {
                $0.removeFromParent()
                return true
            } else {
                return false
            }
        }
    }
    
    private func knockRandItem() {
        
        guard
            let treeChild = treeChildGroup.randomChild(),
            let childNode = treeChild.node
            else { return }
        
        let dropItem: SKSpriteNode
        
        dropItem = makeCoconutNode(at: childNode.position)
        dropItem.zPosition = childNode.zPosition
        dropItem.name = "coconut"
        dropItem.physicsBody = SKPhysicsBody(circleOfRadius: childNode.size.width/2 - 9)
        dropItem.physicsBody?.categoryBitMask = CollisionType.coconut.rawValue
        
        dropItem.physicsBody?.density = 352
        dropItem.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.floor.rawValue
        dropItem.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.floor.rawValue
        
        let size = childNode.size
        
        treeChild.isActive = false
        
        // Shake the coconut before dropping it
        let sequence = SKAction.sequence([
            .move(by: .init(dx: -5, dy: 0), duration: 0.1),
            .move(by: .init(dx: 5, dy: 0), duration: 0.1)
        ])
        
        childNode.run(SKAction.repeatForever(sequence))
        
        childNode.run(SKAction.wait(forDuration: TimeInterval.random(in: 0.2..<2))) { [weak self] in
            
            guard let self = self else { return }
            
            childNode.removeAllActions()
            childNode.removeFromParent()
            treeChild.coconut = nil
            
            self.addChild(dropItem)
            self.fallingChildNodes.append(dropItem)
            
            let group = SKAction.group([
                .scale(to: size, duration: 0.7),
                .fadeIn(withDuration: 0.2)
            ])
            
            // regrow the coconut
            let newCoconut = self.makeCoconutNode(at: treeChild.coconutPos)
            newCoconut.zPosition = treeChild.position.zPosition
            newCoconut.alpha = 0
            newCoconut.size = CGSize(width: 5, height: 5)
            self.addChild(newCoconut)
            
            newCoconut.run(group) {
                treeChild.coconut = newCoconut
                treeChild.isActive = true
            }
            
        }
    }
    
    func runMonkeyBombAnimation() {
        guard let monkey = monkey else { return }
        
        monkey.dropBombAnimation {
            
            let bombSize = monkey.bomb.size
            
            let dropBomb = self.makeBombNode(at: self.convert(monkey.bomb.position, from: monkey))
            dropBomb.ignite()
            dropBomb.name = "bomb"
            dropBomb.zPosition = ZPosition.bombs
            let bombCircleRadius = (bombSize.width * 0.64) / 2
            dropBomb.physicsBody = SKPhysicsBody(
                circleOfRadius: bombCircleRadius,
                center: CGPoint(x: bombSize.width * 0.43 - (bombSize.width/2),
                                y: bombSize.height/2 - (bombSize.height * 0.65))
            )
            dropBomb.physicsBody?.categoryBitMask = CollisionType.bomb.rawValue
            dropBomb.physicsBody?.density = 352
            dropBomb.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.floor.rawValue
            dropBomb.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.floor.rawValue
            
            monkey.bomb.alpha = 0
            self.addChild(dropBomb)
            self.fallingChildNodes.append(dropBomb)
        }
    }
    
    func knockRandChild() {
        
        knockRandItem()
    }
    
    func setupTree(isVisibleInScene: Bool) {
        removeAllChildren()
        removeAllActions()
        
        fallingChildNodes.forEach { $0.removeFromParent() }
        
        zPosition = ZPosition.palmTree
        fallingChildNodes = []
        addChild(treeNode)
        treeChildGroup = TreeChildGroup()
        configureCoconuts()
        addMonkeyWithBomb()
        
        if isVisibleInScene == false {
            addFloatingBananaNode()
        }
    }
}

extension PalmTree {
    
    enum Position: String {
        case top
        case left
        case right
        
        var zPosition: CGFloat {
            switch self {
            case .top: return ZPosition.Coconut.top
            case .left: return ZPosition.Coconut.left
            case .right: return ZPosition.Coconut.right
            }
        }
    }
    
    final class TreeChildNode {
        
        var coconutPos: CGPoint!
       
        var coconut: Coconut? {
            didSet {
                guard let nodePos = coconut?.position else { return }
                coconutPos = nodePos
                coconut?.zPosition = position.zPosition
            }
        }
        
        var isActive: Bool = false
        var position: Position
        
        var node: SKSpriteNode? {
            return self.coconut
        }
        
        init(position: Position) {
            self.position = position
        }
        
        init(node: SKSpriteNode, position: Position) {
            self.position = position
            if let coconut = node as? Coconut {
                self.coconut = coconut
            } else {
                fatalError("Not a valid tree child")
            }
        }
    }
    
    struct TreeChildGroup {
        var top = TreeChildNode(position: .top)
        var left = TreeChildNode(position: .left)
        var right = TreeChildNode(position: .right)
        
        var all: [TreeChildNode] {
            return [top, left, right]
        }
        
        func setActive() {
            all.forEach { $0.isActive = true }
        }
        
        func randomChild() -> TreeChildNode? {
            all.filter { $0.isActive && $0.coconut != nil }
                .randomElement()
        }
        
        func coconuts() -> [Coconut] {
            all.compactMap { $0.coconut }
        }
    }
    
}
