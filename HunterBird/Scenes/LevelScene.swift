//
//  LevelScene.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 13.08.2022.
//

import SpriteKit

class LevelScene: SKScene {
    
    var sceneAdminDelegate : SceneAdminDelegate?
    
    
    
    override func didMove(to view: SKView) {
        showLevelScene()
    }
    
    
    
    func showLevelScene() {
        
        let levelBackground = SKSpriteNode(imageNamed: "backgroundLevel")
        levelBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        levelBackground.scale(size: frame.size, width: true, rate: 1.0)
        levelBackground.zPosition = ZPozition.background
        addChild(levelBackground)
        
        let rowStartPoint = frame.midY*3/2
        let columnStartPoint = frame.midX/2
         
        
        var level = 1
        let data = UserDefaults.standard
        var maxLevel = data.integer(forKey: "maxLevel")
        
        maxLevel = maxLevel <= 0 ? 1 : maxLevel
        
        
        for row in 0 ... 2 {
            for column in 0 ... 2 {
                
                let btnLevel = SKButton(btnDefaultName: "woodButton", run: showGameScene, index: level)
                
                btnLevel.position = CGPoint(x: CGFloat(column)*columnStartPoint + columnStartPoint, y: rowStartPoint - CGFloat(row)*frame.midY/2)
                
                
                btnLevel.zPosition = ZPozition.offGameBackGround
                btnLevel.isUserInteractionEnabled = level > maxLevel ? false : true
                
                addChild(btnLevel)
                
                
                let lblLevel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                lblLevel.fontColor = level > maxLevel ? .red : .white
                lblLevel.fontName = "Avenir Next"
                lblLevel.text = "\(level)"
                lblLevel.verticalAlignmentMode = .center
                lblLevel.horizontalAlignmentMode = .center
                lblLevel.fontSize = 200.0
                lblLevel.scale(size: btnLevel.size, width: false, rate: 0.45)
                lblLevel.zPosition = ZPozition.labelMenu
                btnLevel.addChild(lblLevel)
                btnLevel.scale(size: frame.size, width: false, rate: 0.25)
                level = level + 1
                
            }
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    func showGameScene(level : Int) {
        sceneAdminDelegate?.showGameScene(level: level)
    }
    
    
    
    
}
