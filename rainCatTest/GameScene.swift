//
//  GameScene.swift
//  rainCatTest
//
//  Created by MAC on 2019/9/26.
//  Copyright © 2019 zhuheming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.5
    private let foodEdgeMargin : CGFloat = 75.0
    
    //成绩
    private var resultNum = 0
    
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    private let backgroundNode = BackgroundNode()
    private let umbrellaNode = UmbrellaSprite.newInstance()
    private var catNode : CatSprite!
    private var foodNode : FoodSprite!
    private let hudNode = HudNode()
    //开始
    override func sceneDidLoad() {
        //UIFontfamilyNames
        hudNode.setup(size: size)
        addChild(hudNode)
        
        self.lastUpdateTime = 0
        
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        umbrellaNode.zPosition = 4
        addChild(umbrellaNode)
        spawnCat()
        spawnFood()
        
        var worldFrame = frame
        worldFrame.origin.x = -size.width/2
        worldFrame.origin.y = -size.height/2
        worldFrame.size.height = size.height
        worldFrame.size.width = size.width
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        self.physicsWorld.contactDelegate = self
    }
    
    //触屏改变雨伞位置
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
    //触屏改变雨伞位置
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrellaNode.setDestination(destination: point)
        }
    }
    
    //更新
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        umbrellaNode.update(deltaTime: dt)
        
        catNode.update(deltaTime: dt, foodLocation: foodNode.position)
        
        // Update the Spawn Timer
        currentRainDropSpawnTime += dt
        
        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }
        if !children.contains(foodNode) {
            spawnFood()
        }
        
        if !children.contains(catNode) {
            spawnCat()
        }
        
        self.lastUpdateTime = currentTime
    }
    
    //雨滴
    private func spawnRaindrop() {
        //let raindrop1 = Raindrop.newInstance(size: size,raindropTexture: raindropTexture)
        
        let raindrop = SKSpriteNode(texture: raindropTexture)
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        
        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width/2)-CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width/2)
        let yPosition = size.height*0.35
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        raindrop.zPosition = 3
        
      // let raindrop2 = Raindrop.newInstance(size: size,raindropTexture: raindropTexture)
        addChild(raindrop)
      //  addChild(raindrop2)
    }
    
    //碰撞调用
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == RainDropCategory) {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        
        if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
            handleFoodHit(contact: contact)
            return
        }
        
        if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
            handleCatCollision(contact: contact)
            
            return
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
    
    //处理猫的物理碰撞
    func handleCatCollision(contact: SKPhysicsContact) {
        var otherBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == CatCategory {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case RainDropCategory:
            catNode.hitByRain()
            hudNode.resetPoints()
        case WorldCategory:
            spawnCat()
        default:
            print("Something hit the cat")
        }
    }
    //画猫
    func spawnCat() {
        if let currentCat = catNode, children.contains(currentCat) {
            catNode.removeFromParent()
            catNode.removeAllActions()
            catNode.physicsBody = nil
        }
        //x随机 y坐标在0以下
        catNode = CatSprite.newInstance()
        var randomPositionx : CGFloat = CGFloat(arc4random())
        randomPositionx = (size.width/4 - randomPositionx.truncatingRemainder(dividingBy: size.width/2)) * 2
        var randomPositiony : CGFloat = CGFloat(arc4random())
        randomPositiony = (0 - randomPositiony.truncatingRemainder(dividingBy: size.height/2))
        catNode.position = CGPoint(x: randomPositionx, y: randomPositiony)
        
        addChild(catNode)
        
        hudNode.resetPoints()
    }
    
    //画食物
    func spawnFood() {
        if let currentFood = foodNode, children.contains(currentFood) {
            foodNode.removeFromParent()
            foodNode.removeAllActions()
            foodNode.physicsBody = nil
        }

        foodNode = FoodSprite.newInstance()
        var randomPositionx : CGFloat = CGFloat(arc4random())
        var randomPositiony : CGFloat = CGFloat(arc4random())
        randomPositionx = (size.width/4 - randomPositionx.truncatingRemainder(dividingBy: size.width/2)) * 2
        randomPositiony = (0 - randomPositiony.truncatingRemainder(dividingBy: size.height/2))
        //randomPosition += foodEdgeMargin
        
        foodNode.position = CGPoint(x: randomPositionx, y: randomPositiony)
        
        addChild(foodNode)
    }
    
    //处理食物的碰撞
    func handleFoodHit(contact: SKPhysicsContact) {
        var otherBody : SKPhysicsBody
        var foodBody : SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask == FoodCategory) {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case CatCategory:
            //TODO increment points
            print("fed cat")
            hudNode.addPoint()
            //吃食物，让食物消失重新出现,猫也重新出现，分数增加，跳出对话框
            foodBody.node?.removeFromParent()
            foodBody.node?.removeAllActions()
            foodBody.node?.physicsBody = nil
            
            catNode.removeFromParent()
            catNode.removeAllActions()
            catNode.physicsBody = nil
            
            resultNum += 1
        case WorldCategory:
            foodBody.node?.removeFromParent()
            foodBody.node?.physicsBody = nil
            
            spawnFood()
        default:
            print("something else touched the food")
        }
    }
}
