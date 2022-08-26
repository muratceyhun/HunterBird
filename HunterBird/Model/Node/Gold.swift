//
//  Gold.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 19.08.2022.
//

import SpriteKit

enum goldType : String {
    case Gold1
    case Gold2
}


class Gold : SKSpriteNode {
    
    let type :  goldType
    let value : Int
    
    init(type : goldType) {
        self.type = type
        
        switch type {
        case .Gold1:
            value = 20
            break
        case .Gold2:
            value = 10
            break
        }
        let texture = SKTexture(imageNamed: type.rawValue)
        super.init(texture: texture, color: .clear, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func formBody () {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategories.gold
        physicsBody?.contactTestBitMask = PhysicsCategories.all
        physicsBody?.collisionBitMask = PhysicsCategories.empty
        
    }
    
    func collision() -> Int {
        removeFromParent()
        return value
    }
    
}
