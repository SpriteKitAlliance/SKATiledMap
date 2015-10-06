//
//  SKAObjectLayer.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

class SKAObjectLayer {
    
    let frame :SKAFrame
    var opacity : Float = 0.0
    var visible : Bool = true
    
    let type : String
    var collisionSprites = [SKASprite]()
    
    var sprites = [[SKASprite]]()
    
    init(frame : SKAFrame, type : String)
    {
        self.frame = frame
        self.type = type
        
        let row = Array(arrayLiteral: SKASprite(), SKASprite(), SKASprite())
        sprites.append(row)
    }
    
}