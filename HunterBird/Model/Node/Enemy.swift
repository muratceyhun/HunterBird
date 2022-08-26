//
//  Enemy.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 17.08.2022.
//

import SpriteKit

enum EnemyType:String {
    case OrangeEnemy
    case GreenEnemy
}

class Enemy : SKSpriteNode {
    
    let enemyType : EnemyType
    var healtValue : Int
    var thresholdValue : Int?
    let animationMoments : [SKTexture]?
    
    init(enemyType : EnemyType) {
        self.enemyType = enemyType
        
        switch enemyType {
            
            
        case .OrangeEnemy:
            healtValue = 180
            animationMoments = AnimationSettings.loadTexture(atlas: SKTextureAtlas(named: enemyType.rawValue), name: enemyType.rawValue)
            thresholdValue = nil
            break
        case .GreenEnemy :
            healtValue = 150
            thresholdValue = healtValue/2
            animationMoments = nil
            break
        }
        
        let texture = SKTexture(imageNamed: enemyType.rawValue+"1")
        super.init(texture: texture, color: .clear, size: .zero)
        addAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    func collision(power : Int) -> Bool {
        
        if healtValue < 0 {
            return false
        }
        
        healtValue = healtValue - power
        
        if healtValue <= 0 {
            removeAllActions()
            let eradication = SKTexture(imageNamed: "eradication")
            texture = eradication
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                self.removeFromParent()
            })
            return true
        }
        
        if let thresholdValue = thresholdValue , healtValue <= thresholdValue {
            let injuredEnemyTexture = SKTexture(imageNamed: enemyType.rawValue+"Injured")
            texture = injuredEnemyTexture
        }
        return false
    }
    
    func formBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategories.enemy
        physicsBody?.contactTestBitMask = PhysicsCategories.all
        physicsBody?.collisionBitMask = PhysicsCategories.all
        
    }
    
    func addAnimation() {
        if let animationMoments = animationMoments {
            run(SKAction.repeatForever(SKAction.animate(with: animationMoments, timePerFrame: 0.3, resize: false, restore: true)))
        }
    }
    
}
    

