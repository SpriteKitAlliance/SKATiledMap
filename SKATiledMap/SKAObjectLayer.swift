//
//  SKAObjectLayer.swift
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
import SpriteKit

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
     SKNode created if special SKACollisionType is defined on an object
     Note: It can be a SKSpriteNode or a SKShapeNode
     */
    var collisionSprites = [SKNode]()
    
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