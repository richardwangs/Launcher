//
//  File.swift
//  Launcher
//
//  Created by Mr StealUrGirl on 8/2/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import Foundation

class Data: NSObject, NSCoding {
    let money : Int;
    
    
    
    required init(coder aDecoder: NSCoder) {
        money = aDecoder.decodeObject(forKey: "money") as! Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(money, forKey: "money")
    }

    
}
