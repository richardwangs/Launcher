//
//  MainMenu.swift
//  Launcher
//
//  Created by Mr StealUrGirl on 8/8/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import Foundation

import SpriteKit

class MainMenu: SKScene {
    
    var buttonPlay : MSButtonNode!
    var buttonUpgrade : MSButtonNode!
    
    
    override func didMove(to view: SKView) {
        
        buttonPlay = childNode(withName: "buttonPlay") as! MSButtonNode
        buttonUpgrade = childNode(withName: "buttonUpgrade") as! MSButtonNode
        
        buttonPlay.selectedHandler = { [unowned self] in
            
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
        
        buttonUpgrade.selectedHandler = { [unowned self] in
            
            let skView = self.view as SKView!
            
            let scene = UpgradeScene(fileNamed: "UpgradeScene") as UpgradeScene!
            
            scene?.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }

    }
    

    
    
}
