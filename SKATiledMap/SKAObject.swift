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
    let y : Int
    
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
    
    var properties = {}
    
    var center : SKACenter {
        return SKACenter(x:x+width/2, y: y+height/2)
    }
    
    
    /**
     Designated Initializer
     @param properties the properties that come from the JSON or TMX file
     */
    init(properties: [String: AnyObject]){
        
        objectID = properties["objectID"] as! String
        name = properties["name"] as! String
        type = properties["type"] as! String
        
        x = properties["width"] as! Int
        y = properties["width"] as! Int
        width = properties["width"] as! Int
        height = properties["width"] as! Int

        self.rotation = 0.0

    }
    
}
