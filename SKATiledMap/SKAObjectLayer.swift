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

    /**
     Opacity defined by Tiled at creation
     */
    let opacity : Float
    
    /**
     Visible defined by Tiled at creation
     */
    let visible : Bool
    
    /**
     Type defined by Tiled at creation
     */
    let type : String
    
    /**
     Name defined by Tiled at creation
     */
    let name : String
    
    /**
     SKASprites created if special SKACollisionType is defined on an object
     */
    var collisionSprites = [SKASprite]()
    
    /**
     Array containing any SKAObjects for this layer
     */
    var objects = [SKAObject]()

    /**
     Array of Sprites based on a 2d grid system may return nil if no sprite for index
     */
    let drawOrder : String
    
    init(properties: [String: AnyObject])
    {
        guard let _ = properties["type"] as? String else{
            fatalError("Error: missing required type for object layer")
        }
        type = properties["type"] as! String

        guard let _ = properties["x"] as? Int else{
            fatalError("Error: missing required x position for object layer")
        }
        x = properties["x"] as! Int

        guard let _ = properties["y"] as? Int else{
            fatalError("Error: missing required y position for object layer")
        }
        y = properties["y"] as! Int

        guard let _ = properties["width"] as? Int else{
            fatalError("Error: missing required width for object layer")
        }
        width = properties["width"] as! Int

        guard let _ = properties["height"] as? Int else{
            fatalError("Error: missing required height for object layer")
        }
        height = properties["height"] as! Int

        guard let _ = properties["opacity"] as? Float else{
            fatalError("Error: missing required opacity for object layer")
        }
        opacity = properties["opacity"] as! Float

        guard let _ = properties["name"] as? String else{
            fatalError("Error: missing required name for object layer")
        }
        name = properties["name"] as! String

        guard let _ = properties["visible"] as? Bool else{
            fatalError("Error: missing required visible for object layer")
        }
        visible = properties["visible"] as! Bool

        guard let _ = properties["draworder"] as? String else{
            fatalError("Error: missing required draworder for object layer")
        }
        drawOrder = properties["draworder"] as! String

    }
    
}