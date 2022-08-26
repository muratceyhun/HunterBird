//
//  Bird.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 10.08.2022.
//

import Foundation
import SpriteKit


enum BirdType : String {
    
    case Grey
    case Blue
    case Yellow
    case Red
    
    
}

class Bird : SKSpriteNode {
    
    let birdType : BirdType
    var chosen : Bool = false
    var fly : Bool = false {
        didSet {
            if fly {
                physicsBody?.isDynamic = true
                flyAnimation(active: true)
            } else {
                flyAnimation(active: false)
            }
        }
    }
    
    let flyShoot : [SKTexture]
    init(birdType : BirdType) {
        self.birdType = birdType
        flyShoot = AnimationSettings.loadTexture(atlas: SKTextureAtlas(named: birdType.rawValue), name: birdType.rawValue)
        
        let texture = SKTexture(imageNamed: birdType.rawValue+"1")
        
        
        super.init(texture: texture, color: .clear, size: texture.size())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    
    func flyAnimation(active : Bool) {
        if active {
            run(SKAction.repeatForever(SKAction.animate(with: flyShoot, timePerFrame: 0.08, resize: true, restore: true)))
        } else {
            removeAllActions()
        }
    }
    
    
}
