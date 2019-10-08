//
//  FoodSprite.swift
//  RainCat
//  Created by MAC on 2019/9/26.
//  Copyright © 2019 zhuheming. All rights reserved.
//

import SpriteKit

public class FoodSprite : SKSpriteNode {
  public static func newInstance() -> FoodSprite {
    let foodDish = FoodSprite(imageNamed: "food_dish")

    foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size)
    foodDish.physicsBody?.affectedByGravity = false
    foodDish.physicsBody?.categoryBitMask = FoodCategory
    foodDish.physicsBody?.contactTestBitMask = WorldCategory | RainDropCategory | CatCategory
    foodDish.zPosition = 5

    return foodDish
  }
}
