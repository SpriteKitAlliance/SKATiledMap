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
    
    
    let objectID : String
    let name : String
    let type : String
    
    var rotation : Float
    
    var visible = true
    
    var properties : [String : AnyObject]?

    
    
    /**
     Designated Initializer
     @param properties the properties that come from the JSON or TMX file
     */
    init(properties: [String: AnyObject]){
        objectID = "0"
//        objectID = properties["objectID"] as! String
        name = properties["name"] as! String
        type = properties["type"] as! String
        
        x = properties["x"] as! Int
        y = properties["y"] as! Int
        width = properties["width"] as! Int
        height = properties["height"] as! Int
        
        self.properties = properties["properties"] as? [String : AnyObject]

        self.rotation = 0.0

    }
    
}
