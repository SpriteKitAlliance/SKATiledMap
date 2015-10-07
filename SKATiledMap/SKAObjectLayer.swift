//
//  SKAObjectLayer.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

class SKAObjectLayer {
    
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
    var visible : Bool = true
    
    let type : String
    var collisionSprites = [SKASprite]()
    
    /**
     Array of Sprites based on a 2d grid system may return nil if no sprite for index
     */
    var sprites = [[SKASprite?]]()
    
    init(properties: [String: AnyObject])
    {
        type = properties["type"] as! String
        
        x = properties["width"] as! Int
        y = properties["width"] as! Int
        width = properties["width"] as! Int
        height = properties["width"] as! Int
    }
    
    func sprite(indexX: Int, indexY: Int) -> SKASprite?{
        if let sprite = sprites[x][y]{
            return sprite
        }
        else
        {
            return nil
        }
    }
    
}