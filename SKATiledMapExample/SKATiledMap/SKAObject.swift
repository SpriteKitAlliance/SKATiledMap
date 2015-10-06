//
//  SKAObject.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation

class SKAObject{
    
    let frame : SKAFrame
    let objectID : String
    let name : String
    let type : String
    
    var rotation : Float
    
    var visible = true
    
    var properties = {}
    
    var center : SKACenter {
        return SKACenter(x:frame.x+frame.width/2, y: frame.y+frame.height/2)
    }
    
    init(frame :SKAFrame, objectID: String, name: String, type: String){
        self.frame = frame
        self.objectID = objectID
        self.rotation = 0.0
        self.name = name
        self.type = type
    }
    
}
