//
//  UpgradeScene.swift
//  Launcher
//
//  Created by Mr StealUrGirl on 7/11/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import SpriteKit

class UpgradeScene: SKScene {
    
    var labelMoney : SKLabelNode!
    var backButton : MSButtonNode!
    var healthButton : MSButtonNode!
    var fazeButton : MSButtonNode!
    var freezeButton : MSButtonNode!
    var buttonBuy : MSButtonNode!
    var costsLabel : SKLabelNode!
    var buying : String = " "
    var playerMoney = player.money{
        didSet {
            labelMoney.text = String(Int(player.money))
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: player)
            UserDefaults.standard.set(encodedData, forKey: "players")
            print("hellggho")
            print(player.money)
            print(player.fazeUpgrade)
            print(player.freezeUpgrade)
        }
        
    }
    var costs = 0.0 {
        didSet {
            costsLabel.text = String(costs)
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        labelMoney = childNode(withName: "labelMoney") as! SKLabelNode
        labelMoney.text = String(Int(playerMoney))
        backButton = childNode(withName: "buttonBack") as! MSButtonNode
        healthButton = childNode(withName: "healthButton") as! MSButtonNode
        fazeButton = childNode(withName: "fazeButton") as! MSButtonNode
        freezeButton = childNode(withName: "freezeButton") as! MSButtonNode
        buttonBuy = childNode(withName: "buttonBuy") as! MSButtonNode
        costsLabel = childNode(withName: "costsLabel") as! SKLabelNode
        
        costsLabel.text = String(costs)
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
        healthButton.selectedHandler = {
            self.buying = "health"
            self.costs = 500.0 * (player.healthUpgrade + 1 )
            print("health")
        }
        fazeButton.selectedHandler = {
            self.buying = "faze"
            self.costs = 10000.0 * (player.fazeUpgrade + 1 )
            print("faze")
        }
        freezeButton.selectedHandler = {
            self.buying = "freeze"
            self.costs = 10000.0 * (player.freezeUpgrade + 1 )
            print("freeze")
        }
        
        buttonBuy.selectedHandler = {
            if player.money >= 10000.0 * (player.freezeUpgrade + 1) && self.buying == "freeze"{
                player.money -= 10000.0 * (player.freezeUpgrade + 1)
                player.freezeUpgrade += 1
                self.playerMoney = player.money
                self.costs = 10000.0 * (player.freezeUpgrade + 1)

            }
            
            if player.money >= 10000.0 * (player.fazeUpgrade + 1)  && self.buying == "faze"{
                player.money -= 10000.0 * (player.fazeUpgrade + 1)
                player.fazeUpgrade += 1
                self.playerMoney = player.money
                self.costs = 10000.0 * (player.fazeUpgrade + 1)
                
            }
            
            if player.money >= 500.0 * (player.healthUpgrade + 1) && self.buying == "health"{
                player.health += 1
                player.money -= 500.0 * (player.healthUpgrade + 1)
                self.playerMoney = player.money
                player.healthUpgrade += 1
                self.costs = 500.0 * (player.healthUpgrade + 1)
            }
            
        }
    }
    
}
