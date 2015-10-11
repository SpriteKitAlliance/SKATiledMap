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

    let opacity : Float
    let visible : Bool
    
    let type : String
    let name : String
    
    var collisionSprites = [SKASprite]()
    var objects = [SKAObject]()

    /**
     Array of Sprites based on a 2d grid system may return nil if no sprite for index
     */
    let drawOrder : String
    
    init(properties: [String: AnyObject])
    {
        type = properties["type"] as! String
        
        x = properties["x"] as! Int
        y = properties["y"] as! Int
        width = properties["width"] as! Int
        height = properties["height"] as! Int
        opacity = properties["opacity"] as! Float
        name = properties["name"] as! String
        visible = properties["visible"] as! Bool
        drawOrder = properties["draworder"] as! String
    }
    
}