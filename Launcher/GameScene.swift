//
//  GameScene.swift
//  Launcher
//
//  Created by Mr StealUrGirl on 7/10/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import SpriteKit
import GameplayKit
import Crashlytics

enum gameState {
    case gameOver , gameActive
}

class GameScene: SKScene , SKPhysicsContactDelegate , UIGestureRecognizerDelegate{
    
    var hero : SKSpriteNode!
    var cameraNode: SKCameraNode!
    var cameraTarget: SKSpriteNode?
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var scrollSpeed : CGFloat = 100.0
    var oldScrollSpeed : CGFloat = 100.0
    var scrollLayer: SKNode!
    var gameState: gameState = .gameActive
    var gameStart = false
    var did = false
//    var powerbar : SKSpriteNode!
//    var powerbg : SKSpriteNode!
    var stayedAlive : Double = 0.0
    var fuelBar : SKSpriteNode!
    var chocolateSource : SKNode!
    var rocketSource : SKNode!
    var spawnTimer : Double =  0
    var deathTimer : Double = 0
    var eggTimer : Double =  0
    var dragonTimer : Double =  0
    var distanceLabel : SKLabelNode!
    var obstacleLayer : SKNode!
    var rocketLayer : SKNode!
    var dragonLayer : SKNode!
    var eggSource : SKNode!
    var dragonSource : SKNode!
    var eggLayer : SKNode!
    var fazeButton : MSButtonNode!
    var indicatorSource : SKNode!
    var buttonUpgrade : MSButtonNode!
    var buttonRestart : MSButtonNode!
    var healthMax = player.health
    var timer : CGFloat = 0
    var shrinked = false
    var fazed = false
    var flyUp = false
    var flyDown = false
    var freezed = false
    var damageTaken = false
    var damageTimer = 0.0
    var highScore : SKLabelNode!
    var leftLabel : SKLabelNode!
    var rightLabel : SKLabelNode!
    var tutorial1 : SKLabelNode!
    var tutorial2 : SKLabelNode!
    var tutorial3 : SKLabelNode!

    var healthLabel : SKLabelNode!
    var distance: Double = 0 {
        didSet {
            distanceLabel.text = "Score : " +  String( Int(distance))
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
    var freezeCooldown  = 0.0 {
        didSet {
            if freezeCooldown <= -1 {
                freezeCooldown = -1
            }
            
        }
    }
    var fazeCooldown  = 0.0 {
        didSet {
            if fazeCooldown <= -1 {
                fazeCooldown = -1
            }


            
        }
    }
    
    
    
    func swipeDown(_ sender:UISwipeGestureRecognizer) {
        gameStart = true

            tutorial2.removeFromParent()

        
        print("swiped down")
        flyDown = true
        flyUp = false

    }
    func swipeUp(_ sender:UISwipeGestureRecognizer) {
        gameStart = true

            tutorial1.removeFromParent()

        print("swipeUp")
        flyDown = false
        flyUp = true


        
    }
    func swipeRight(_ sender:UISwipeGestureRecognizer) {
        print("swipeRight")
        if self.freezeCooldown <= 0 {
            freeze()
            
        }
    }
    
    func singleTap(_ sender:UITapGestureRecognizer) {

            gameStart = true
                    tutorial3.removeFromParent()

        print("singleTap")
        flyDown = false
        flyUp = false
        hero.physicsBody?.velocity.dy = CGFloat(0)

    }
    
    func swipeLeft(_ sender:UISwipeGestureRecognizer) {
        print("swipeLeft")
        if self.fazeCooldown <= 0{
            self.faze()
            self.fazeCooldown = 10 - player.fazeUpgrade
         }
        
    }
    
    
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    

    
    override func didMove(to view: SKView) {

        if let data = UserDefaults.standard.data(forKey: "players") {
            player = (NSKeyedUnarchiver.unarchiveObject(with: data) as? Player)!
            print(player.money)
        } else {
            print("There is an issue")
        }
        hero = childNode(withName: "hero") as! SKSpriteNode
        cameraNode = self.childNode(withName: "cameraNode") as! SKCameraNode
        self.camera = cameraNode
        scrollLayer = childNode(withName: "scrollLayer")
        distanceLabel = childNode(withName: "//distanceLabel") as! SKLabelNode
        buttonRestart = childNode(withName: "//buttonRestart") as! MSButtonNode
        fuelBar = childNode(withName: "//fuelBar") as! SKSpriteNode
        healthLabel = childNode(withName: "//health") as! SKLabelNode
        buttonUpgrade = childNode(withName: "//buttonUpgrade") as! MSButtonNode
        chocolateSource = childNode(withName: "chocolate")
        eggSource = childNode(withName: "egg")
        rocketSource = childNode(withName: "rocket")
        dragonSource = childNode(withName: "dragon")
        obstacleLayer = childNode(withName: "obstacleLayer")
        dragonLayer = childNode(withName: "dragonLayer")
        rocketLayer = childNode(withName: "rocketLayer")
        eggLayer = childNode(withName: "eggLayer")
        tutorial1 = childNode(withName: "//tutorial1") as! SKLabelNode
        tutorial2 = childNode(withName: "//tutorial2") as! SKLabelNode
        tutorial3 = childNode(withName: "//tutorial3") as! SKLabelNode

        indicatorSource = childNode(withName: "indicator")
        highScore = childNode(withName: "//highScore") as! SKLabelNode
        leftLabel = childNode(withName: "//leftLabel") as! SKLabelNode
        rightLabel = childNode(withName: "//rightLabel") as! SKLabelNode

        physicsWorld.contactDelegate = self
        healthLabel.text = String(Int(health))
//        leftLabel.text = String(fazeCooldown)
        leftLabel.isHidden = true
//        rightLabel.text = String(freezeCooldown)
        highScore.text = "HighScore : " + String(Int( player.highScore))
        highScore.isHidden = true
        rightLabel.isHidden = true
        healthMax = player.health

        health  = player.health
        
        let swipeDown:UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeDown( _:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        
        let swipeUp:UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeUp( _:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        
        let swipeRight:UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeRight( _:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        let singleTap:UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(GameScene.singleTap( _:)))
        singleTap.numberOfTapsRequired = 1

        let swipeLeft:UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeLeft( _:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view?.addGestureRecognizer(singleTap)
        self.view?.addGestureRecognizer(swipeLeft)
        self.view?.addGestureRecognizer(swipeUp)
        self.view?.addGestureRecognizer(swipeRight)
        self.view?.addGestureRecognizer(swipeDown)
//
        

        
        
        buttonRestart.selectedHandler = { [unowned self] in
            
            
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
        buttonRestart.state = .MSButtonNodeStateHidden
        
        buttonUpgrade.selectedHandler = { [unowned self] in
            
            let skView = self.view as SKView!
            
            let scene = UpgradeScene(fileNamed: "UpgradeScene") as UpgradeScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
        buttonUpgrade.state = .MSButtonNodeStateHidden
        

        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        hero.position.x = 0
        checkGameState()
        if gameState != .gameActive {
            if did != true{
                did = true
                player.money += distance
                let death = SKAction(named : "Death")!
    
                let wait = SKAction.wait(forDuration: 1)
                let indicatorDeath = SKAction.run({
                    self.hero.removeFromParent()
                })
                let seq = SKAction.sequence([death , indicatorDeath])
                hero.run(seq)

            }
            buttonRestart.state = .MSButtonNodeStateActive
            buttonUpgrade.state = .MSButtonNodeStateActive
            highScore.isHidden = false
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: player)
            UserDefaults.standard.set(encodedData, forKey: "players")
            if distance > player.highScore{
                
                player.highScore = distance
                highScore.text = "New HighScore : " + String(Int( player.highScore))
            }
            self.view?.gestureRecognizers?.removeAll()
            return
        }
        
        cameraNode.position.y = hero.position.y
        cameraNode.position.x = hero.position.x + 160
        
        if flyUp == true {
//            if (hero.physicsBody?.velocity.dy)! < CGFloat(-250.0) {
//                hero.physicsBody?.velocity.dy = CGFloat(0)
//            }
//            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: 750))
            hero.physicsBody?.velocity.dy = CGFloat(450)

        }
        if flyDown == true {
//            if (hero.physicsBody?.velocity.dy)! > CGFloat(250.0){
//                hero.physicsBody?.velocity.dy = CGFloat(0)
//            }
//            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: -750))
            hero.physicsBody?.velocity.dy = CGFloat(-450)

        }
        
        if gameStart {
            if player.freezeUpgrade > 0{
                rightLabel.isHidden = false
            }
            if player.fazeUpgrade > 0 {
                leftLabel.isHidden = false
            }
            if timer >= 2{
                faze()
                timer = 0
            }
            if fazed {
                timer += CGFloat(1.00 * fixedDelta)
            }

            if freezed {

            }
                
            else{
                distance += Double(1 * fixedDelta)
                stayedAlive += 1 * fixedDelta
                scrollWorld()
                updateObstacle()


            }
            leftLabel.text = String(Int(fazeCooldown + 1))
            rightLabel.text = String(Int(freezeCooldown + 1))
            fazeCooldown -= 1.0 * fixedDelta
            freezeCooldown -= 1.0 * fixedDelta

            

            if damageTimer >= 0.55 {
                damageTaken = false
                hero.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.5))
                damageTimer = 0
            }
            if damageTaken == true {
                damageTimer += 1.0 * fixedDelta
            }
        }


        
    }
    
    
    
    func updateObstacle(){
        

        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        rocketLayer.position.x -= (scrollSpeed * 7) * CGFloat(fixedDelta)
        dragonLayer.position.x += scrollSpeed * CGFloat(fixedDelta)

        for chocolate in obstacleLayer.children as! [SKReferenceNode]{
            
            let obstaclePosition = obstacleLayer.convert(chocolate.position, to: self)
            
            if obstaclePosition.x <= -590{
                
                chocolate.removeFromParent()
            }
        }
        
        for egg in eggLayer.children as! [SKReferenceNode]{
            
            let obstaclePosition = eggLayer.convert(egg.position, to: self)
            
            if obstaclePosition.x <= -590{
                
                egg.removeFromParent()
            }
        }
        
        for dragon in dragonLayer.children as! [SKReferenceNode]{
            let obstaclePosition = dragonLayer.convert(dragon.position, to: self)
            
            if obstaclePosition.x >= 600{
                
                dragon.removeFromParent()
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
        eggLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        dragonLayer.position.x += scrollSpeed * CGFloat(fixedDelta)

        
        if spawnTimer >= 0.75 {
            
            let newObstacle = chocolateSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            
            let randomPosition = CGPoint(x: cameraNode.position.x + 400 , y: CGFloat.random(min: -88 , max: 560))
            
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            spawnTimer = 0
        }
        
        if eggTimer >= 2 {
            let newObstacle = eggSource.copy() as! SKNode
            eggLayer.addChild(newObstacle)
            
            let randomPosition = CGPoint(x: cameraNode.position.x + 400 , y: CGFloat.random(min: -88 , max: 560))

            newObstacle.position = self.convert(randomPosition, to: eggLayer)
            eggTimer = 0
            
        }
        
//        if dragonTimer >= 20 {
//            let newObstacle = dragonSource.copy() as! SKNode
//            dragonLayer.addChild(newObstacle)
//            let randomPosition = CGPoint(x: cameraNode.position.x - 600 , y: cameraNode.position.y )
//            
//            newObstacle.position = self.convert(randomPosition, to: dragonLayer)
//            dragonTimer = 0
//            
//        }

        
        if deathTimer >= 4  {
            
            let randomPosition = CGPoint(x: cameraNode.position.x + 500  , y: CGFloat.random(min: cameraNode.position.y - 160 , max: cameraNode.position.y + 160))
            let newIndicator = indicatorSource.copy() as! SKNode
            addChild(newIndicator)
            newIndicator.position.y = randomPosition.y
            newIndicator.position.x = cameraNode.position.x + 250
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
            eggTimer += 1.00 * fixedDelta
            dragonTimer += 1.00 * fixedDelta
            if scrollSpeed  != 0 {
                scrollSpeed +=  1.0/60
            }
        }
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        
        if nodeA.name == "egg" {
            nodeA.run(SKAction.removeFromParent())
            distance += 100
        }
        if nodeB.name == "egg" {
            nodeB.run(SKAction.removeFromParent())
            distance += 100

        }
//        if nodeA.name == "dragon"{
//            print("hello")
//            nodeB.run(SKAction.removeFromParent())
//        }
//        if nodeB.name == "dragon"{
//            print("hello")
//            nodeA.run(SKAction.removeFromParent())
//        }
//        

        if damageTaken == false {
            if nodeA.name == "chocolate" || nodeB.name == "chocolate" {
                if shrinked == true{
                    health -= 2
                }
                else {health -= 1
                }
                damageTaken = true
                hero.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.5))

            }
            if nodeA.name == "rocket" || nodeB.name == "rocket" {
                if shrinked == true{
                    health -= 4
                    
                }
                else {health -= 2

                }
                damageTaken = true
                hero.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0.5))

            }
        }

        
        
        
    }
    
    func checkGameState(){
        if gameStart == true{
            if  health <= 0 {
                gameState = .gameOver
                flyUp = false
                flyDown = false
            }
        }
    }
    
    func faze(){
        if player.fazeUpgrade > 0 {
            self.fazed = !self.fazed
            if self.fazed == true{
                self.hero.physicsBody?.categoryBitMask = 0
                self.hero.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.5))
            }
            else {
                self.hero.physicsBody?.categoryBitMask = 1
                self.hero.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.5))
                
                
            }
        }
    }
    
    func freeze(){
        if player.freezeUpgrade > 0{
            self.freezed = !self.freezed
            if freezed == true{
                oldScrollSpeed = scrollSpeed
                print(oldScrollSpeed)
                scrollSpeed = 0
                
            }
            else {
                scrollSpeed = oldScrollSpeed
                print(oldScrollSpeed)
                freezeCooldown = 10 - player.freezeUpgrade
            }
            
        }
        
    }
    func summonDragon(){
        let newObstacle = dragonSource.copy() as! SKNode
        dragonLayer.addChild(newObstacle)
        let randomPosition = CGPoint(x: cameraNode.position.x - 600 , y: cameraNode.position.y )
        
        newObstacle.position = self.convert(randomPosition, to: dragonLayer)
    }
    
    
    
    func scrollWorld(){
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for background in scrollLayer.children as! [SKSpriteNode]{
            
            let backgroundPosition = scrollLayer.convert(background.position, to: self)
            
            if backgroundPosition.x <= -background.size.width {
                
                let newPosition = CGPoint(x: background.size.width - 20, y: backgroundPosition.y)
                
                background.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    
}
extension CGVector {
    public func length() -> CGFloat {
        return CGFloat(sqrt(dx*dx + dy*dy))
    }
}
