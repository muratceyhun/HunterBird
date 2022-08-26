//
//  GameViewController.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 8.08.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .red
        super.viewDidLoad()
        showMenuScene()
        
    }

    
}


protocol SceneAdminDelegate {
    
    func showGameScene(level : Int)
    func showMenuScene()
    func showLevelScene()
    
}


extension GameViewController : SceneAdminDelegate {
    
    
    func showGameScene(level: Int) {
        
        let sceneName = "GameScene\(level)"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
            gameScene.sceneAdminDelegate = self
            gameScene.levelNumber = level
            show(scene: gameScene)
        }
        
    }
    
    func showMenuScene() {
        let menu = MenuScene()
        menu.sceneAdminDelegate = self
        show(scene: menu)
    }
    
    func showLevelScene() {
        let level = LevelScene()
        level.sceneAdminDelegate = self
        show(scene: level)
        
    }
    
    func show(scene : SKScene) {
        if let view = self.view as! SKView? {
            
            if let grArray = view.gestureRecognizers {
                for gr in grArray {
                    view.removeGestureRecognizer(gr)
                }
            }
            
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
        }
    }
    
    
    
}
