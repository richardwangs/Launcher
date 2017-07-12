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
    var playerMoney = player.money{
        didSet {
            labelMoney.text = String(playerMoney)
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        labelMoney = childNode(withName: "labelMoney") as! SKLabelNode
        labelMoney.text = String(playerMoney)

    }

}
