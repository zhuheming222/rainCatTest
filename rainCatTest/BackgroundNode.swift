//
//  BackgroundNode.swift
//  RainCat
//
//  Created by Marc Vandehey on 9/27/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import SpriteKit

public class BackgroundNode : SKNode {

  public func setup(size : CGSize) {
// 屏幕size 750 1334   是否应该设置从-375 -662 到 375 762 ?
    let startPoint = CGPoint(x: -size.width/2, y: -size.height/2)
    let endPoint = CGPoint(x: size.width/2, y: size.height/2)

    physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    physicsBody?.restitution = 0.3
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory

    //天空开始节点位置,为何高度*0.4就超出屏幕?
    let skyNodeStartPoint = CGPoint(x: -size.width/2, y: size.height*0.35)
    //天空尺寸
    let skyNodeSize = CGSize(width: size.width, height: 100)
    //设置天空区域
    let skyNode = SKShapeNode(rect: CGRect(origin: skyNodeStartPoint, size: skyNodeSize))
    skyNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
    skyNode.strokeColor = SKColor.clear
    skyNode.zPosition = 2

    //大地尺寸
    let groundSize = CGSize(width: size.width, height: size.height)
    let groundNode = SKShapeNode(rect: CGRect(origin: startPoint, size: groundSize))
    groundNode.fillColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
    groundNode.strokeColor = SKColor.clear
    groundNode.zPosition = 1

    addChild(skyNode)
    addChild(groundNode)

  }
}
