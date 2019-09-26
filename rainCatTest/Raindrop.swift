//
//  raindrop.swift
//  rainCatTest
//
//  Created by MAC on 2019/9/26.
//  Copyright © 2019 zhuheming. All rights reserved.
//

import SpriteKit

public class Raindrop : SKSpriteNode {
    
    public static func newInstance(size : CGSize,raindropTexture:SKTexture) -> Raindrop {
        
        let raindrop = Raindrop()
        raindrop.texture = raindropTexture
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: CGSize(width: 20,height: 20))
        raindrop.physicsBody?.categoryBitMask = RainDropCategory
        raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory
        //x的位置根据随机产生的正负值对宽度/2取余数。
        let xPosition = (CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width/2)) - (CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width/2))
        let yPosition = size.height/2 + raindrop.size.height/2
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        raindrop.zPosition = 3
        return raindrop;
    }
    
}
