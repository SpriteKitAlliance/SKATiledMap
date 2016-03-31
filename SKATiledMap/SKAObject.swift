//
//  SKAObject.swift
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

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

    var polygon : [[String: Int]]?
    
    var isEllipse = false

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

        self.polygon = properties["polygon"] as? [[String: Int]]

        guard let _  = properties["rotation"] as? Float else{
            fatalError("Error: required rotation is missing on tile object")
        }
        rotation = properties["rotation"] as! Float
        
        guard let _  = properties["visible"] as? Bool else{
            fatalError("Error: required visible is missing on tile object")
        }
        visible = properties["visible"] as! Bool
        
        guard let _  = properties["ellipse"] as? Bool else{
            fatalError("Error: required ellipse is missing on tile object")
        }
        isEllipse = properties["ellipse"] as! Bool
        
    }
    
}
