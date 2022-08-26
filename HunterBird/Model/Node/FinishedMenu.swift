//
//  FinishedMenu.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 18.08.2022.
//

import SpriteKit


struct FinishedMenuButtons {
    static let menu = 1
    static let next = 2
    static let replay = 3
    
}


class FinishedMenu : SKSpriteNode {
    
    let type : Int
    var menuButtonDelegate : MenuButtonDelegate?
    
    init(type : Int, size : CGSize) {
        
        self.type = type
        super.init(texture: nil, color: .clear, size: size)
        showMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func showMenu () {
        
        let background = type == 1 ? SKSpriteNode(imageNamed: "successful") : SKSpriteNode(imageNamed: "unsuccessful")
        
        background.scale(size: size, width: false, rate: 0.5)
        
        let btnMenu = SKButton(btnDefaultName: "menu", run: buttonAdmin, index: FinishedMenuButtons.menu)
        let btnNext = SKButton(btnDefaultName: "next", run: buttonAdmin, index: FinishedMenuButtons.next)
        let btnReplay = SKButton(btnDefaultName: "replay", run: buttonAdmin, index: FinishedMenuButtons.replay)
        
        btnNext.isUserInteractionEnabled = type == 1 ? true : false
        
        btnMenu.scale(size: background.size, width: true, rate: 0.2)
        btnNext.scale(size: background.size, width: true, rate: 0.2)
        btnReplay.scale(size: background.size, width: true, rate: 0.2)

        
        let backgroundWidth = background.size.width/2
        let backgroundHeight = background.size.height/2
        let buttonWidth = btnNext.size.width/2
        let buttonHeight = btnNext.size.height/2
        
        
        btnMenu.position = CGPoint(x: buttonWidth-backgroundWidth, y: -(buttonHeight+backgroundHeight))
        btnNext.position = CGPoint(x: 0, y: -(backgroundHeight+buttonHeight))
        btnReplay.position = CGPoint(x: backgroundWidth-buttonWidth, y: -(backgroundHeight+buttonHeight))
        background.position = CGPoint(x: 0, y: buttonHeight)
        
        addChild(btnMenu)
        addChild(btnNext)
        addChild(btnReplay)
        addChild(background)

        
    }
    
    
    func buttonAdmin(index : Int) {
        
        switch index {
            
        case FinishedMenuButtons.menu :
            
            menuButtonDelegate?.btnMenuPressed()
            break
            
        case FinishedMenuButtons.next :
            menuButtonDelegate?.btnNextPressed()
            break
        case FinishedMenuButtons.replay :
            menuButtonDelegate?.btnReplayPressed()
            break
            
        default :
            break
        }
        
    }
}




protocol MenuButtonDelegate {
    
    func btnMenuPressed()
    func btnNextPressed()
    func btnReplayPressed()
       
}
