//
//  File.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/10/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

/**
 This class is only used to to hold texture info during SKATiledMap creation
 */
class SKAMapTile {
    
    let texture : SKTexture
    var properties : [String : AnyObject]?
    
    init (texture : SKTexture)
    {
        self.texture = texture
    }
}