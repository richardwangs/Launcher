//
//  Player.swift
//  Launcher
//
//  Created by Mr StealUrGirl on 7/12/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import Foundation

class Player : NSObject, NSCoding  {
    var money : Double = 50000
    var health : Double = 5
    var healthUpgrade : Double = 0
    var shrinkUpgrade : Double = 0
    var freezeUpgrade : Double = 0
    var fazeUpgrade : Double = 0
    var highScore : Double = 0
    
    
    init(money:Double, health: Double) {
        self.money = money
        self.health = health

    }
    
    required init(coder decoder: NSCoder) {
        self.money = decoder.decodeDouble(forKey: "money")
        self.health = decoder.decodeDouble(forKey: "health")
        self.highScore = decoder.decodeDouble(forKey: "highScore")
        self.healthUpgrade = decoder.decodeDouble(forKey: "healthUpgrade")
        self.freezeUpgrade = decoder.decodeDouble(forKey: "freezeUpgrade")
        self.fazeUpgrade = decoder.decodeDouble(forKey: "fazeUpgrade")

        

    }
    func encode(with coder: NSCoder) {
        coder.encode(money, forKey: "money")
        coder.encode(health, forKey: "health")
        coder.encode(highScore, forKey: "highScore")
        coder.encode(healthUpgrade, forKey: "healthUpgrade")
        coder.encode(freezeUpgrade, forKey: "freezeUpgrade")
        coder.encode(fazeUpgrade, forKey: "fazeUpgrade")

    }
}
var player = Player(money:  10000000, health: 5)

