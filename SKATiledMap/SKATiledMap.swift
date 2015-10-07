//
//  SKATiledMap.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class SKATiledMap : SKNode{

    /**
     Number of columns for the map
     */
    let mapWidth : Int
    
    /**
     Number of rows for the map
     */
    let mapHeight : Int
    
    /**
     Width of a single tile
     */
    let tileWidth : Int
    
    /**
     Height of a single tile
     */
    let tileHeight : Int
    
    /**
     returns an array of SKASpriteLayers
     */
    var spriteLayers = [SKASpriteLayer]()
    
    /**
     returns an array of SKAObjectLayers
     */
    var objectLayers = [SKAObjectLayer]()

    var mapProperties = [String : AnyObject]()
    
    var autoFollowNode : SKNode?
    
    
    init(mapName: String){
        
        mapWidth = 0
        mapHeight = 0
        tileWidth = 0
        tileHeight = 0

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        
    }
    
    func index(point : CGPoint){
        
    }
    
    func tilesAround(point : CGPoint)-> [SKASprite?]{
        return [SKASprite]()
    }
    
    func tileAround(index : CGPoint) -> [SKASprite?]{
        return [SKASprite]()
    }
    
    func sprite(layer : Int, x : Int, y : Int) -> SKASprite{
        return SKASprite()
    }
    
    
    
}