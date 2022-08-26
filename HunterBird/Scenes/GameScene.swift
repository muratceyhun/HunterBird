//
//  GameScene.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 8.08.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var sceneAdminDelegate : SceneAdminDelegate?
    let gameCamera = GameCamera()
    var mapNode = SKTileMapNode()
    var panGR = UIPanGestureRecognizer()
    var pinchGR = UIPinchGestureRecognizer()
    var maxScale : CGFloat = 0
    var bird = Bird(birdType: .Blue)
    var birds = [Bird]()
    var levelNumber : Int?
    let anchor = SKNode()
    var gameSituation : GameSituation = .Ready
    var point = 0
    let lblPoint = SKLabelNode(fontNamed: "Chalkduster")
    
    var numberOfEnemy = 0 {
        didSet {
            if numberOfEnemy < 1 {
                print("All enemies have eradicated.")
                
                if let level = levelNumber {
                    let data = UserDefaults.standard
                    data.set(level+1, forKey: "maxLevel")
                    data.set(point, forKey: "point")
                }
                showFinishedMenu(successful: true)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        point = UserDefaults.standard.integer(forKey: "point")
        addPoint()
        guard let levelNumber = levelNumber else {return}
        
        guard let levelData = Level(level: levelNumber) else {return}
        
        for color in levelData.birds {
            if let newBirdType = BirdType(rawValue: color) {
                let newBird = Bird(birdType: newBirdType)
                birds.append(newBird)
            }
        }

        
        
        
        setupLevel()
        prepareGR()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameSituation {
        case .Ready:
            if let touch = touches.first {
                let location = touch.location(in: self)
                if bird.contains(location) {
                    panGR.isEnabled = false
                    bird.chosen = true
                    bird.position = location
                }
            }
            break
            
            
        case .Flying:
            break
        case .Finish:
            guard let view = view else {return}
            gameSituation = .Resurrection
            let cameraBackAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 2.0)
            cameraBackAction.timingMode = .easeInEaseOut
            gameCamera.run(cameraBackAction, completion: {
                self.panGR.isEnabled = true
                self.addBird()
            })
            break
            
        case .Resurrection:
            break
        case .GameOver:
            break
       
        }
        
        
        
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first {
            
            if bird.chosen {
                let location = touch.location(in: self)
                bird.position = location
            }
        }
      }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bird.chosen {
            gameCamera.determineBorders(scene: self, frame: mapNode.frame, node: bird)
            bird.chosen = false
            panGR.isEnabled = true
            anchorDetermineBorder(active: false)
            bird.fly = true
            gameSituation = .Flying
            let xDelta = anchor.position.x - bird.position.x
            let yDelta = anchor.position.y - bird.position.y
            
            let impulse = CGVector(dx: xDelta, dy: yDelta)
            bird.physicsBody?.applyImpulse(impulse)
            bird.isUserInteractionEnabled = false
        }
    }
    
    func addCamera(){
        addChild(gameCamera)
        guard let view = view else {return}
        gameCamera.setScale(maxScale)
        gameCamera.determineBorders(scene: self, frame: mapNode.frame, node: nil)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = gameCamera
    }
    
    
    func prepareGR() {
        guard let view = view else {return}
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        
        pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchGR)
    }
    
    @objc func pinch(p : UIPinchGestureRecognizer) {
        guard let view = view else {return}
        
        if p.numberOfTouches == 2 { // The number of user's touch on screen
            
            let locationView = p.location(in: view) // It shows pinch's location
            let location = convertPoint(fromView: locationView)
            
            if p.state == .changed {
                let scale = 1 / p.scale
                let newScale = gameCamera.yScale*scale
                if newScale < maxScale && newScale > 0.5 {
                    gameCamera.setScale(newScale)
                }
                let locationAfterScale = convertPoint(fromView: locationView)
                
                let locationDelta = location - locationAfterScale
                let newLocation = gameCamera.position + locationDelta
                
                gameCamera.position = newLocation
                p.scale = 1.0
                gameCamera.determineBorders(scene: self, frame: mapNode.frame, node: nil)
            }
            
            
            
        }
    }
    
    
    @objc func pan(p:UIPanGestureRecognizer) {
        guard let view = view else {return}
        let movement = p.translation(in: view) * gameCamera.yScale
        gameCamera.position = CGPoint(x: gameCamera.position.x-movement.x, y: gameCamera.position.y+movement.y)
        gameCamera.determineBorders(scene: self, frame: mapNode.frame, node: nil)
        
        p.setTranslation(CGPoint.zero, in: view)
    }
    
    
    
    func setupLevel() {
        
        if let map = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = map
            maxScale = mapNode.mapSize.width / frame.size.width
            
        }
        addCamera()
        
        for node in mapNode.children {
            
            if let node = node as? SKSpriteNode {
                
                guard let name = node.name else {continue}
                
                switch name {
                    
                case "Glass","Wood","Stone" :
                    if let block = addBlock(node: node, name: name) {
                        mapNode.addChild(block)
                        node.removeFromParent()
                    }
                    break
                    
                case "OrangeEnemy","GreenEnemy" :
                    if let enemy = addEnemy(node: node, name: name) {
                    mapNode.addChild(enemy)
                    numberOfEnemy = numberOfEnemy + 1
                    node.removeFromParent()
                    }
                    break
                case "Gold1","Gold2" :
                    
                    if let gold = addGold(node: node, name: name) {
                    mapNode.addChild(gold)
                    node.removeFromParent()
                }
                    break
                default:
                    break
                }
                 
                
            }
            
            
            
        }
        
        let rect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        

        
        
        
        physicsBody?.categoryBitMask = PhysicsCategories.side
        physicsBody?.contactTestBitMask = PhysicsCategories.bird | PhysicsCategories.block
        physicsBody?.collisionBitMask = PhysicsCategories.all
        anchor.position = CGPoint(x: frame.width/2, y: frame.height/1.8)
        addChild(anchor)
        addBird()
        addSlingshot()
    }
    
    
    func addGold(node : SKSpriteNode, name : String) -> Gold? {
        guard let goldType = goldType(rawValue: name) else {return nil}
        
        let gold = Gold(type: goldType)
        gold.position = node.position
        gold.size = node.size
        gold.formBody()
        gold.zPosition = ZPozition.bird
        gold.zRotation = node.zRotation
        return gold
    }
    
    
    func addBlock(node : SKSpriteNode, name : String) -> Block? {
        
        guard let blockType = TypeOfBlock(rawValue: name) else {return nil}
        
        
        let block = Block(type: blockType)
        
        
        block.position = node.position
        block.size = node.size
        block.zPosition = ZPozition.obstacle
        block.zRotation = node.zRotation
        block.formBody()
        return block
    }
    
    
    func addEnemy(node : SKSpriteNode, name : String) -> Enemy? {
        guard let enemyType = EnemyType(rawValue: name) else {return nil}
        let enemy = Enemy(enemyType: enemyType)
        enemy.size = node.size
        enemy.position = node.position
        enemy.formBody()
        return enemy
    }
    
    func addSlingshot() {
        
        let slingshot = SKSpriteNode(imageNamed: "slingshot")
        let scaleDimension = CGSize(width: 0, height: mapNode.frame.midY/2 - mapNode.tileSize.height/2)
        slingshot.scale(size: scaleDimension, width: false, rate: 1)
        
        slingshot.position = CGPoint(x: anchor.position.x, y: slingshot.size.height/2 + mapNode.tileSize.height)
        
        slingshot.zPosition = ZPozition.obstacle
        mapNode.addChild(slingshot)
        
    }
    
    
    func addBird(){
        
        
        if birds.isEmpty {
            print("You don't have any bird anymore...")
            gameSituation = .GameOver
            showFinishedMenu(successful: false)
            return
        }
        
        bird = birds.removeFirst()
        gameSituation = .Ready
        
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.categoryBitMask = PhysicsCategories.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategories.all
        bird.physicsBody?.collisionBitMask = PhysicsCategories.block | PhysicsCategories.side
        bird.physicsBody?.isDynamic = false
        bird.zPosition = ZPozition.bird
        bird.position = anchor.position
        bird.scale(size: mapNode.tileSize, width: true, rate: 1.0)
        addChild(bird)
        anchorDetermineBorder(active: true)
    }
    
    
    func anchorDetermineBorder(active : Bool) {
        
        if active {
            let tensionRange = SKRange(lowerLimit: 0.0, upperLimit: bird.size.width*2.8)
            let birdConstraint = SKConstraint.distance(tensionRange, to: anchor)
            bird.constraints = [birdConstraint]
        } else {
            
            bird.constraints?.removeAll()
            
        }
        
    }
    
    
    
    override func didSimulatePhysics() {
        guard let body = bird.physicsBody else {return}
        
        if gameSituation == .Flying && body.isResting {
            gameCamera.determineBorders(scene: self, frame: mapNode.frame, node: nil)
            bird.removeFromParent()
            gameSituation = .Finish
        }
        
        
    }
    
    func showFinishedMenu(successful : Bool) {
        let type = successful ? 1 : 2
        let menu = FinishedMenu(type: type, size: frame.size)
        
        
        menu.zPosition = ZPozition.offGameBackGround
        menu.menuButtonDelegate = self
        gameCamera.addChild(menu)
    }
    
    
    func addPoint(){
        let screenDimension = UIScreen.main.bounds
        let screenWidth = screenDimension.width
        let screenHeight = screenDimension.height
        lblPoint.position = CGPoint(x: screenWidth/2, y: screenHeight/2.5)
        lblPoint.fontColor = .orange
        lblPoint.text = "Score : \(point)"
        lblPoint.verticalAlignmentMode = .top
        lblPoint.horizontalAlignmentMode = .right
        lblPoint.fontSize = 25
        lblPoint.zPosition = ZPozition.obstacle
        gameCamera.addChild(lblPoint)
    }
}

extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {

        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
        case PhysicsCategories.bird | PhysicsCategories.block , PhysicsCategories.block | PhysicsCategories.side :
            
            
            if let block = contact.bodyA.node as? Block {
                block.collision(power: Int(contact.collisionImpulse))
            } else if let block = contact.bodyB.node as? Block {
                block.collision(power: Int(contact.collisionImpulse))
            }
            
            if let bird = contact.bodyA.node as? Bird {
                bird.fly = false
            } else if let bird = contact.bodyB.node as? Bird {
                bird.fly = false
            }
            break
            
        case PhysicsCategories.block | PhysicsCategories.block :
            
            if let block = contact.bodyA.node as? Block {
                block.collision(power: Int(contact.collisionImpulse))
            }
            
            if let block = contact.bodyB.node as? Block {
                block.collision(power : Int(contact.collisionImpulse))
            }
            break
      
            
        case PhysicsCategories.bird | PhysicsCategories.side :
            
            bird.fly = false
            break
            
        case PhysicsCategories.bird | PhysicsCategories.enemy , PhysicsCategories.block | PhysicsCategories.enemy :
            
            if let enemy = contact.bodyA.node as? Enemy {
                if enemy.collision(power: Int(contact.collisionImpulse)) {
                    numberOfEnemy = numberOfEnemy - 1
                }
                
            } else if let enemy = contact.bodyB.node as? Enemy {
                if enemy.collision(power: Int(contact.collisionImpulse)) {
                    numberOfEnemy = numberOfEnemy - 1
                }
            }
            break
            
        case PhysicsCategories.bird | PhysicsCategories.gold :
            if let gold = contact.bodyA.node as? Gold {
                point = point + gold.collision()
            } else if let gold = contact.bodyB.node as? Gold {
                point = point + gold.collision()
            }
            lblPoint.text = "Score = \(point)"
            print("ScoreBoard = \(point)")
            
        default :
            break
        }
    }
    
}


extension GameScene : MenuButtonDelegate {
    func btnMenuPressed() {
        
        sceneAdminDelegate?.showLevelScene()
        
    }
    
    func btnNextPressed() {
        if let level = levelNumber {
            sceneAdminDelegate?.showGameScene(level: level+1)
        }
        
    }
    
    func btnReplayPressed() {
        if let level = levelNumber {
            sceneAdminDelegate?.showGameScene(level: level)
        
        }
    
    }
}
