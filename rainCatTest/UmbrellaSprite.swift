//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by MAC on 2019/9/26.
//  Copyright © 2019 zhuheming. All rights reserved.
//

import SpriteKit

public class UmbrellaSprite : SKSpriteNode {
  private var destination : CGPoint!
  private let easing : CGFloat = 0.1

  public static func newInstance() -> UmbrellaSprite {
    let umbrella = UmbrellaSprite(imageNamed: "umbrella")
    
    let path = UIBezierPath()
    path.move(to: CGPoint())
    path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
    path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
    path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

    umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
    umbrella.physicsBody?.isDynamic = false
    umbrella.physicsBody?.restitution = 0.9

    return umbrella
  }

  public func updatePosition(point : CGPoint) {
    position = point
    destination = point
  }

  public func setDestination(destination : CGPoint) {
    self.destination = destination
  }

  public func update(deltaTime : TimeInterval) {
    let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))

    if(distance > 1) {
      let directionX = (destination.x - position.x)
      let directionY = (destination.y - position.y)

      position.x += directionX * easing
      position.y += directionY * easing
    } else {
      position = destination;
    }
  }
}
