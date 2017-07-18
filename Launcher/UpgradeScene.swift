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
    var healthLabel : SKLabelNode!
    var playerMoney = player.money{
        didSet {
            labelMoney.text = String(playerMoney)
        }
    }
    var healthCosts = 50.0 * player.healthUpgrade {
        didSet {
            healthLabel.text = String(healthCosts)
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        labelMoney = childNode(withName: "labelMoney") as! SKLabelNode
        labelMoney.text = String(playerMoney)
        backButton = childNode(withName: "buttonBack") as! MSButtonNode
        healthButton = childNode(withName: "healthButton") as! MSButtonNode
        healthLabel = childNode(withName: "healthLabel") as! SKLabelNode
        healthLabel.text = String(healthCosts)

        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
        healthButton.selectedHandler = {
            if player.money >= 500.0 * player.healthUpgrade{
            player.health += 2
            player.money -= 50.0 * player.healthUpgrade
            self.playerMoney = player.money
            player.healthUpgrade += 1
            self.healthCosts = 50.0 * player.healthUpgrade
        }
        }
    }

}
