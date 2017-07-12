//
//  GameScene.swift
//  Launcher
//
//  Created by Mr StealUrGirl on 7/10/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AudioToolbox.AudioServices

enum gameState {
    case gameOver , gameActive
}

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    var hero : SKSpriteNode!
    var cameraNode: SKCameraNode!
    var cameraTarget: SKSpriteNode?
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    let scrollSpeed : CGFloat = 100
    var scrollLayer: SKNode!
    var add = true
    var barSpeed = 0.01
    var gameState: gameState = .gameActive
    var touchEnd = false
    var powerbar : SKSpriteNode!
    var background : SKSpriteNode!
    var defaultbackground : SKSpriteNode!
    var backgroundSky : SKSpriteNode!
    var ground : SKSpriteNode!
    var powerbg : SKSpriteNode!
    var glide = true
    var fuel : Double = 10
    var distanceLabel : SKLabelNode!
    var buttonUpgrade : MSButtonNode!
    var buttonRestart : MSButtonNode!
    var distance: Int = 0 {
        didSet {
            distanceLabel.text = String(distance)
        }
    }
    var power : CGFloat = 0{
        didSet {
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            if power > 1 { power = 1.0 }
            powerbar.xScale = power
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        hero = childNode(withName: "hero") as! SKSpriteNode
        cameraNode = self.childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        scrollLayer = childNode(withName: "scrollLayer")
        powerbar = childNode(withName: "powerbar") as! SKSpriteNode
        powerbg = childNode(withName: "powerbg") as! SKSpriteNode
        distanceLabel = childNode(withName: "//distanceLabel") as! SKLabelNode
        buttonRestart = childNode(withName: "//buttonRestart") as! MSButtonNode
        background = childNode(withName: "background") as! SKSpriteNode
        defaultbackground = childNode(withName: "background") as! SKSpriteNode
        backgroundSky = childNode(withName: "backgroundSky") as! SKSpriteNode
        ground = childNode(withName: "ground") as! SKSpriteNode
        buttonUpgrade = childNode(withName: "buttonUpgrade") as! MSButtonNode
        physicsWorld.contactDelegate = self
        buttonRestart.selectedHandler = {
            
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
            player.money += self.distance
            print(player.money)
        }
        buttonRestart.state = .MSButtonNodeStateHidden

        buttonUpgrade.selectedHandler = {
            
            let skView = self.view as SKView!
            
            let scene = UpgradeScene(fileNamed: "UpgradeScene") as UpgradeScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        checkGameState()

        if gameState != .gameActive{
            buttonRestart.state = .MSButtonNodeStateActive
            return
        }

        cameraNode.position = hero.position
        if touchEnd != true {
            powerBar()
        }
        
        distance = Int(hero.position.x)
        if hero.position.x > 2 && glide == true && fuel >= 0{
            
            hero.physicsBody?.applyForce(CGVector(dx: 70, dy: 650))
            print("asdfasdf")
            fuel -= 1 * fixedDelta
            print(fuel)
        }
        
        spawnBackGround()
        
    }
    func spawnBackGround(){
        if cameraNode.position.y >= backgroundSky.position.y || cameraNode.position.y >= defaultbackground.position.y + 800{
            let newSky = SKSpriteNode(imageNamed: "layer-1-sky")
            newSky.zPosition = -2
            newSky.position.x = hero.position.x + 200
            newSky.position.y = hero.position.y + 800
            addChild(newSky)
            self.backgroundSky = newSky
        }
        if cameraNode.position.x >= (background.position.x + 1000 ){
            let newbackground = SKSpriteNode(imageNamed: "Full-Background")
            newbackground.zPosition = -2
            newbackground.position.x = hero.position.x + 20
            newbackground.position.y = 480
            addChild(newbackground)
            self.background = newbackground

        }
        if cameraNode.position.x >= (ground.position.x){
            let newground = SKSpriteNode(imageNamed: "ground")
            newground.position.x = hero.position.x + 20
            newground.position.y =  -269.599
            newground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            newground.physicsBody?.affectedByGravity = false
            newground.physicsBody?.isDynamic = false
            newground.physicsBody?.allowsRotation = false
            addChild(newground)
            self.ground = newground
            
        }
        
    }
    
    func powerBar(){
        if power >= 1 {
            add = false
            barSpeed = 0

        }
        if power <= 0{
            add = true
            barSpeed = 0

        }
        if add {
            barSpeed += 0.01
            power += CGFloat(barSpeed)
        }
        if add != true{
            power -= 0.02

        }
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Get references to bodies involved in collision */
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        /* Did our hero pass through the 'goal'? */
        if nodeA.name == "boostObstacle" || nodeB.name == "boostObstacle" {
            
            hero.physicsBody?.applyImpulse(CGVector(dx: 100 * power , dy: 300 * power ))
            return
        }
        if nodeA.name == "Chocolate" || nodeB.name == "Chocolate" {
            
            hero.physicsBody?.applyImpulse(CGVector(dx: -100  , dy: 300  ))
            print("asdasdzx")
            return
        }


        
    }
    
    func checkGameState(){
        if hero.position.x > 1{
            if hero.physicsBody!.velocity.length() < 0.18 {
                gameState = .gameOver
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: self)
        print(location)
        
        glide = !glide
        }

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd = true
        hero.physicsBody?.allowsRotation = true
        if hero.position.x <= 1{
            hero.physicsBody?.velocity = (CGVector(dx: 0 , dy:0 ))
            hero.physicsBody?.applyImpulse(CGVector(dx: 150 * power , dy: 560 * power ))
    }
        powerbg.removeFromParent()
        powerbar.removeFromParent()
        
    
}
}
extension CGVector {
    public func length() -> CGFloat {
        return CGFloat(sqrt(dx*dx + dy*dy))
    }
}
