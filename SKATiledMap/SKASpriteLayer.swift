//
//  SKASpriteLayer.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

class SKASpriteLayer {
    
    /**
    X position defined by Tiled at creation
    */
    let x : Int
    
    /**
    Y position defined by Tiled at creation
    */
    let y : Int
    
    /**
    Width defined by Tiled at creation
    */
    let width : Int
    
    /**
    Height defined by Tiled at creation
    */
    let height : Int
    
    var opacity : Float = 0.0
    var visible = true
    
    var type : String
    var collisionSprites = [SKASprite]()

    
    init(properties: [String: AnyObject]){
        
        type = properties["type"] as! String
        
        x = properties["width"] as! Int
        y = properties["width"] as! Int
        width = properties["width"] as! Int
        height = properties["width"] as! Int
        
//        self.rotation = 0.0
        
    }


    
}