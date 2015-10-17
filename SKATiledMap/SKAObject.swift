//
//  SKAObject.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

class SKAObject{
    
    /**
     X position defined by Tiled at creation
     */
    let x : Int
    
    /**
     Y position defined by Tiled at creation
     y position is flipped based on layer draworder
     */
    var y : Int
    
    /**
     Width defined by Tiled at creation
     */
    let width : Int
    
    /**
     Height defined by Tiled at creation
     */
    let height : Int
    
    /**
     Name defined by Tiled at creation
     */
    let name : String
    
    /**
     Type defined by Tiled at creation
     */
    let type : String
    
    /**
     Rotation defined by Tiled at creation
     */
    var rotation : Float
    
    /**
     Visible defined by Tiled at creation
     */
    var visible : Bool
    
    var properties : [String : AnyObject]?

    /**
     Designated Initializer
     @param properties the properties that come from the JSON or TMX file
     */
    init(properties: [String: AnyObject]){
        
        guard let _ = properties["name"] as? String else{
            fatalError("Error: required name property missing on tile object")
        }
        name = properties["name"] as! String

        guard let _ = properties["type"] as? String else{
            fatalError("Error: required type property missing on tile object")
        }
        type = properties["type"] as! String
        
        
        guard let _ = properties["x"] as? Int else{
            fatalError("Error: required x position is missing on tile object")
        }
        x = properties["x"] as! Int

        guard let _ = properties["y"] as? Int else{
            fatalError("Error: required y position is missing on tile object")
        }
        y = properties["y"] as! Int

        guard let _  = properties["width"] as? Int else {
            fatalError("Error: required width is missing on tile object")
        }
        width = properties["width"] as! Int

        guard let _ = properties["height"] as? Int else{
            fatalError("Error: required height is missing on tile object")
        }
        height = properties["height"] as! Int

        
        self.properties = properties["properties"] as? [String : AnyObject]

        guard let _  = properties["rotation"] as? Float else{
            fatalError("Error: required rotation is missing on tile object")
        }
        rotation = properties["rotation"] as! Float
        
        guard let _  = properties["visible"] as? Bool else{
            fatalError("Error: required visible is missing on tile object")
        }
        visible = properties["visible"] as! Bool

    }
    
}
