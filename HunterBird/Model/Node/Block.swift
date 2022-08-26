//
//  Block.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 11.08.2022.
//

import Foundation
import SpriteKit


class Block : SKSpriteNode {
    
    let type : TypeOfBlock
    var health : Int
    let damage : Int
    
    init(type : TypeOfBlock) {
        
        self.type = type
        
        
        switch type {
            
        case .Stone:
            health = 250
            break
        case .Glass:
            health = 70
            break
        case .Wood:
            health = 150
            break
        }
        
        damage = (2*health)/5
        let texture = SKTexture(imageNamed: type.rawValue.lowercased())
        super.init(texture: texture, color: .clear, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    
    
    func formBody() {
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategories.block
        physicsBody?.contactTestBitMask = PhysicsCategories.all
        physicsBody?.collisionBitMask = PhysicsCategories.all
        
    }
    
    func collision(power : Int) {

        health -= power
        
        
        if health < 0 {
            removeFromParent()
        } else if health < damage {

            let brokenBlock = SKTexture(imageNamed:"broken"+type.rawValue)
            texture = brokenBlock

        }
    }
   

}


enum TypeOfBlock : String {
    
    case Stone
    case Glass
    case Wood
    
    
}
