//
//  SKButton.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 13.08.2022.
//

import SpriteKit


class SKButton : SKSpriteNode {
    
    var btnDefault : SKSpriteNode
    var run : (Int) -> ()
    var index : Int
    
    
    
    init(btnDefaultName : String, run : @escaping(Int) -> (), index : Int) {
        
        btnDefault = SKSpriteNode(imageNamed: btnDefaultName)
        self.run = run
        self.index = index
        
        super.init(texture: nil, color: .clear, size: btnDefault.size)
        isUserInteractionEnabled = true
        addChild(btnDefault)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        btnDefault.alpha = 0.65 // Button is working with clicked effect
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        if btnDefault.contains(location) {
            run(index)
        }
        
        btnDefault.alpha = 1.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        btnDefault.alpha = 1.0
    }
    
    
    
    
}
