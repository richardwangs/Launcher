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
    var motionManager: CMMotionManager!
    var cameraNode: SKCameraNode!
    var cameraTarget: SKSpriteNode?
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    let scrollSpeed : CGFloat = 100
    var scrollLayer: SKNode!
    var add = true
    var barSpeed = 0.01
    var gameState: gameState = .gameActive
    var touchEnd = false
    var gameStart = false
    var powerbar : SKSpriteNode!
    var powerbg : SKSpriteNode!
    var fuelBar : SKSpriteNode!
    var chocolateSource : SKNode!
    var rocketSource : SKNode!
    var spawnTimer : Double =  0
    var deathTimer : Double = 0
    var distanceLabel : SKLabelNode!
    var obstacleLayer : SKNode!
    var rocketLayer : SKNode!
    var indicatorSource : SKNode!
    var buttonUpgrade : MSButtonNode!
    var buttonRestart : MSButtonNode!
    var healthMax = player.health
    var healthLabel : SKLabelNode!
    var distance: Double = 0 {
        didSet {
            distanceLabel.text = String(Int(distance))
        }
    }
    var power : CGFloat = 0{
        didSet {
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            if power > 1 { power = 1.0 }
            powerbar.xScale = power
        }
    }
    var health  = player.health {
        didSet {
            if health <= 0 {
                health = 0
            }
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            fuelBar.xScale = CGFloat(0.135 * health/healthMax)
            healthLabel.text = String(Int(health))
            print(health/healthMax)
            
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
        fuelBar = childNode(withName: "//fuelBar") as! SKSpriteNode
        healthLabel = childNode(withName: "//health") as! SKLabelNode
        buttonUpgrade = childNode(withName: "//buttonUpgrade") as! MSButtonNode
        chocolateSource = childNode(withName: "chocolate")
        rocketSource = childNode(withName: "rocket")
        obstacleLayer = childNode(withName: "obstacleLayer")
        rocketLayer = childNode(withName: "rocketLayer")
        indicatorSource = childNode(withName: "indicator")
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        physicsWorld.contactDelegate = self
        healthLabel.text = String(Int(health))
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
        
        
        if gameState != .gameActive{
            buttonRestart.state = .MSButtonNodeStateActive
            return
        }

        
        cameraNode.position = hero.position
        
        if let data = motionManager.accelerometerData {
            let x = data.acceleration.x
            hero.physicsBody?.velocity.dx = 0


            var oldX: CGFloat = hero.position.x
            var newX: CGFloat = (self.size.width/2)*CGFloat(x)
            
            if gameStart == true && health >= 0{
                if(abs(abs(oldX) - abs(newX)) > 0.01) {
//                    print(x)
                    // Use the accelerometer data in your app.
                    if x > 0.5 {
//                        hero.physicsBody?.applyForce(CGVector(dx: 70, dy: 650))
                       hero.physicsBody?.applyForce(CGVector(dx: 0, dy: 350))
        


                        
                    }
                    if x < 0.5 {
//                        hero.physicsBody?.applyForce(CGVector(dx: 120, dy: -750))
                        hero.physicsBody?.applyForce(CGVector(dx: 0, dy: -350))

                        
                    }
                    
                }
                
                
            }
        }
        
        
        checkGameState()

        if touchEnd != true {
            powerBar()
        }
        
        if gameStart == true{
            updateObstacle()
            scrollWorld()
            distance += Double(1 * fixedDelta)


        }

//        spawnBackGround()
    }
    
//    func spawnBackGround(){
//        if cameraNode.position.y >= backgroundSky.position.y || cameraNode.position.y >= defaultbackground.position.y + 800{
//            let newSky = SKSpriteNode(imageNamed: "layer-1-sky")
//            newSky.zPosition = -2
//            newSky.position.x = hero.position.x + 200
//            newSky.position.y = hero.position.y + 800
//            addChild(newSky)
//            self.backgroundSky = newSky
//        }
//        if cameraNode.position.x >= (background.position.x + 1000 ){
//            let newbackground = SKSpriteNode(imageNamed: "Full-Background")
//            newbackground.zPosition = -2
//            newbackground.position.x = hero.position.x + 20
//            newbackground.position.y = 480
//            addChild(newbackground)
//            self.background = newbackground
//
//        }
//        if cameraNode.position.x >= (ground.position.x){
//            let newground = SKSpriteNode(imageNamed: "ground")
//            newground.position.x = hero.position.x + 100
//            newground.position.y =  -269.599
//            newground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//            newground.physicsBody?.affectedByGravity = false
//            newground.physicsBody?.isDynamic = false
//            newground.physicsBody?.allowsRotation = false
//            addChild(newground)
//            self.ground = newground
//            
//        }
//        

    
    func updateObstacle(){
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        rocketLayer.position.x -= (scrollSpeed * 7) * CGFloat(fixedDelta)

        for chocolate in obstacleLayer.children as! [SKReferenceNode]{
            
            let obstaclePosition = obstacleLayer.convert(chocolate.position, to: self)
            
            if obstaclePosition.x <= -590{
                
                chocolate.removeFromParent()
            }
        }
        
        for rocket in rocketLayer.children as! [SKReferenceNode]{
            
            let obstaclePosition = rocketLayer.convert(rocket.position, to: self)
            
            if obstaclePosition.x <= -590{
                
                rocket.removeFromParent()
            }
        }
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        rocketLayer.position.x -= (scrollSpeed * 7) * CGFloat(fixedDelta)


        
        if spawnTimer >= 1  {
            
            let newObstacle = chocolateSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            
            let randomPosition = CGPoint(x: cameraNode.position.x + 400 , y: CGFloat.random(min: cameraNode.position.y - 160 , max: cameraNode.position.y + 160))
            
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            spawnTimer = 0
        }
        if deathTimer >= 4 {
            
            let randomPosition = CGPoint(x: cameraNode.position.x + 400  , y: CGFloat.random(min: cameraNode.position.y - 160 , max: cameraNode.position.y + 160))
            let newIndicator = indicatorSource.copy() as! SKNode
            addChild(newIndicator)
            newIndicator.position.y = randomPosition.y
            newIndicator.position.x = cameraNode.position.x + 200
            let wait = SKAction.wait(forDuration: 1)
            let indicatorDeath = SKAction.run({
                newIndicator.removeFromParent()
                let newObstacle = self.rocketSource.copy() as! SKNode
                self.rocketLayer.addChild(newObstacle)
                newObstacle.position = self.convert(randomPosition, to: self.rocketLayer)
            })
            let seq = SKAction.sequence([wait, indicatorDeath])
            run(seq)
            

            deathTimer = 0
        }
        else{
            
            spawnTimer += 1.00 * fixedDelta
            deathTimer += 1.00 * fixedDelta

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
            print("hello")
            return
        }
        if nodeA.name == "chocolate" || nodeB.name == "chocolate" {
            health -= 1
            print("asdasdzx")
            return
        }
        if nodeA.name == "rocket" || nodeB.name == "rocket" {
            health -= 2
            print("asdasdzx")
            return
        }

        
        }
    
    func checkGameState(){
        if gameStart == true{
//            if hero.physicsBody!.velocity.length() < 0.18 ||
              if  health <= 0 {
                gameState = .gameOver
            }
        }
    }
    func scrollWorld(){
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for background in scrollLayer.children as! [SKSpriteNode]{
            
            let backgroundPosition = scrollLayer.convert(background.position, to: self)
            
            if backgroundPosition.x <= -background.size.width / 2 {
                
                let newPosition = CGPoint(x: (self.size.width / 2) + background.size.width, y: backgroundPosition.y)
                
                background.position = self.convert(newPosition, to: scrollLayer)
            }
        }
//        for ground in scrollLayer.children as! [SKSpriteNode]{
//            
//            let groundPosition = scrollLayer.convert(ground.position, to: self)
//            
//            if groundPosition.x <= -ground.size.width / 2 {
//                
//                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
//                
//                ground.position = self.convert(newPosition, to: scrollLayer)
//            }
//
//        }
//        for ceiling in scrollLayer.children as! [SKSpriteNode]{
//            
//            let ceilingPosition = scrollLayer.convert(ceiling.position, to: self)
//            
//            if ceilingPosition.x <= -ceiling.size.width / 2 {
//                
//                let newPosition = CGPoint(x: (self.size.width / 2) + ceiling.size.width, y: ceilingPosition.y)
//                
//                ceiling.position = self.convert(newPosition, to: scrollLayer)
//            }
//
//        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: self)
        print(location)
        print(hero.physicsBody?.velocity)
        hero.setScale(0.3)
        hero.physicsBody?.mass = 0.300000637769699
        }

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func rightsw
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnd = true
        hero.physicsBody?.allowsRotation = true
        if gameStart == false{
            hero.physicsBody?.velocity = (CGVector(dx: 0 , dy:0 ))
            hero.physicsBody?.applyImpulse(CGVector(dx: 0 * power , dy: 560 * power ))
            gameStart = true

    }
        powerbg.removeFromParent()
        powerbar.removeFromParent()
        buttonUpgrade.removeFromParent()
        
    
}
}
extension CGVector {
    public func length() -> CGFloat {
        return CGFloat(sqrt(dx*dx + dy*dy))
    }
}
