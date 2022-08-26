//
//  AnimationSettings.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 16.08.2022.
//

import SpriteKit


class AnimationSettings {
    
    static func loadTexture(atlas : SKTextureAtlas, name : String ) -> [SKTexture] {
        
        var textures = [SKTexture]()
    
        for i in 1...atlas.textureNames.count {
            
            let textureName = name + String(i)
            textures.append(atlas.textureNamed(textureName))
            
        }
        
        return textures
    }
  
}
