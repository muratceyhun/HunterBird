//
//  MenuScene.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 13.08.2022.
//

import SpriteKit


class MenuScene : SKScene {
    var sceneAdminDelegate : SceneAdminDelegate?
    
    
    override func didMove(to view: SKView) {
        showMenu()
    }
    
    func showMenu() {
        
        let menuBackground = SKSpriteNode(imageNamed: "backgroundMenu")
        menuBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        menuBackground.scale(size: frame.size, width: true, rate: 1.0)
        menuBackground.zPosition = ZPozition.background
        addChild(menuBackground)
        
        let btnPlay = SKButton(btnDefaultName: "playButton", run: showLevelScene, index: 0)
        
        btnPlay.position = CGPoint(x: frame.midX, y: frame.midY)
        btnPlay.zPosition = ZPozition.labelMenu
        btnPlay.scale(size: frame.size, width: false, rate: 0.3)
        addChild(btnPlay)
    }
    
    
    func showLevelScene(_ : Int) {
        sceneAdminDelegate?.showLevelScene()
        
    }

}
