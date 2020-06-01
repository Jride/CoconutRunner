//
//  PalmTree.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 06/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import SpriteKit

class PalmTree: GameNode {
    
    enum Position: String {
        case top
        case left
        case right
        
        var zPosition: CGFloat {
            switch self {
            case .top: return 1
            case .left: return 2
            case .right: return 3
            }
        }
    }
    
    class TreeChildNode {
        
        var coconutPos: CGPoint!
        var bombPos: CGPoint!
       
        var coconut: Coconut? {
            didSet {
                guard let nodePos = coconut?.position else { return }
                coconutPos = nodePos
                coconut?.zPosition = position.zPosition
            }
        }
        var bomb: Bomb? {
            didSet {
                guard let nodePos = bomb?.position else { return }
                bombPos = nodePos
            }
        }
        
        var isActive: Bool = false
        var position: Position
        
        var node: SKSpriteNode? {
            if let coconut = self.coconut {
                return coconut
            } else {
                return bomb
            }
        }
        
        init(position: Position) {
            self.position = position
        }
        
        init(node: SKSpriteNode, position: Position) {
            self.position = position
            if let coconut = node as? Coconut {
                self.coconut = coconut
            } else if let bomb = node as? Bomb {
                self.bomb = bomb
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
            all.filter { $0.isActive && ($0.coconut != nil || $0.bomb != nil) }
                .randomElement()
        }
        
        func coconuts() -> [Coconut] {
            all.compactMap { $0.coconut }
        }
    }
    
    var fallingChildNodes = [TreeChildNode]()
    
    static let originalSize = SKTexture(imageNamed: "palmTree").size()
    
    private var treeChildGroup = TreeChildGroup()
    private lazy var coconutSize: CGSize = {
        return Coconut.size()
    }()
    
    init(size: CGSize) {
        
        let texture = SKTexture(imageNamed: "palmTree")
        super.init(texture: texture, color: .white, size: size)
        
        configureCoconuts()
        addFloatingBananaNode(at: CGPoint(x: 0, y: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCoconuts() {
        
        let top = makeCoconutNode(at: CGPoint(x: 0,
                                              y: coconutSize.height/2 + (35 * Env.gameState.scaleFactor)))
        treeChildGroup.top.coconut = top
        
        let left =  makeCoconutNode(at: CGPoint(x: -15,
                                                y: coconutSize.height/2 + (15 * Env.gameState.scaleFactor)))
        treeChildGroup.left.coconut = left
        
        let right = makeCoconutNode(at: CGPoint(x: 15,
                                                y: coconutSize.height/2 + (15 * Env.gameState.scaleFactor)))
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
    
    private func addFloatingBananaNode(at point: CGPoint) {
        
        let banana = Banana.newInstance()
        banana.position = CGPoint(x: point.x + banana.size.width/2 + (10 * Env.gameState.scaleFactor),
                                  y: point.y - 60 * Env.gameState.scaleFactor)
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
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        
        guard let parent = self.parent else { return }
        
        // Remove all the coconuts that are out of frame
        fallingChildNodes.removeAll {
            guard let coconut = $0.coconut else { return true }
            if parent.intersects(coconut) == false {
                coconut.removeFromParent()
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
        
        if childNode is Coconut {
            dropItem = makeCoconutNode(at: childNode.position)
            dropItem.zPosition = childNode.zPosition
            dropItem.name = "coconut"
            dropItem.physicsBody = SKPhysicsBody(circleOfRadius: childNode.size.width/2 - 9)
            dropItem.physicsBody?.categoryBitMask = CollisionType.coconut.rawValue
        } else {
            treeChild.bomb?.ignite()
            
            let bombItem = makeBombNode(at: childNode.position)
            bombItem.zPosition = childNode.zPosition
            bombItem.ignite()
            
            dropItem = bombItem
            dropItem.name = "bomb"
            dropItem.physicsBody = SKPhysicsBody(circleOfRadius: (bombItem.size.width * 0.64) / 2,
                                                 center: CGPoint(x: bombItem.size.width * 0.43 - (bombItem.size.width/2),
                                                                 y: bombItem.size.height/2 - (bombItem.size.height * 0.65)))
            dropItem.physicsBody?.categoryBitMask = CollisionType.bomb.rawValue
        }
        
        dropItem.physicsBody?.density = 352
        dropItem.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.floor.rawValue
        dropItem.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.floor.rawValue
        
        let position = childNode.position
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
            treeChild.bomb = nil
            
            self.addChild(dropItem)
            self.fallingChildNodes.append(.init(node: dropItem, position: treeChild.position))
            
            let group = SKAction.group([
                .scale(to: size, duration: 0.7),
                .fadeIn(withDuration: 0.2)
            ])
            
            func growCoconut() {
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
            
            func growBomb() {
                let newBomb = self.makeBombNode(at: position)
                newBomb.zPosition = treeChild.position.zPosition
                
                // Adjust position of bomb compared to the position of the coconut
                var newPos = newBomb.position
                newPos.x += 2
                newPos.y += 8
                
                newBomb.position = newPos
                newBomb.alpha = 0
                newBomb.size = CGSize(width: 5, height: 5)
                self.addChild(newBomb)
                
                newBomb.run(group) {
                    treeChild.bomb = newBomb
                    treeChild.isActive = true
                }
            }
            
            if dropItem is Bomb {
                // If the dropped item was a bomb then we must regrow a coconut
                growCoconut()
            } else {
                // TODO: Add game logic for bomb birth rate
                growBomb()
            }
            
        }
    }
    
    func knockRandChild() {
        
        knockRandItem()
    }
    
    func reset() {
        removeAllChildren()
        removeAllActions()
        
        fallingChildNodes = []
        treeChildGroup = TreeChildGroup()
        configureCoconuts()
        addFloatingBananaNode(at: CGPoint(x: 0, y: 0))
    }
}
