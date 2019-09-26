//
//  GameScene.swift
//  rainCatTest
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.3
    
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    private let backgroundNode = BackgroundNode()
    private let umbrellaNode = UmbrellaSprite.newInstance()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        addChild(umbrellaNode)
        
        var worldFrame = frame
        worldFrame.origin.x = 0
        worldFrame.origin.y = 0
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        umbrellaNode.update(deltaTime: dt)
        
        // Update the Spawn Timer
        currentRainDropSpawnTime += dt
        
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }
        
        self.lastUpdateTime = currentTime
    }
    
    private func spawnRaindrop() {
        //let raindrop1 = Raindrop.newInstance(size: size,raindropTexture: raindropTexture)
        
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        
        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width/2)
        let yPosition = size.height/2 + raindrop.size.height/2
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        raindrop.zPosition = 3
        
       let raindrop2 = Raindrop.newInstance(size: size,raindropTexture: raindropTexture)
        addChild(raindrop)
        addChild(raindrop2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        if contact.bodyA.categoryBitMask == WorldCategory {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
}
