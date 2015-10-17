//
//  SKASpriteLayer.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

/**
 SKASpriteLayer is a SKNode generated from a Tiled sprite layer 
 */
class SKASpriteLayer : SKNode {
    
    /**
     Type defined by Tiled at creation
     */
    var type : String
    
    /**
     A 2D array of SKASprites to easily access tiles for specific indexes
     */
    var sprites = [[SKASprite]]()

    
    init(properties: [String: AnyObject]){
        
        guard let _ = properties["type"] as? String else{
            fatalError("Error: missing type for Sprite Layer")
        }
        type = properties["type"] as! String
        
        super.init()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
}