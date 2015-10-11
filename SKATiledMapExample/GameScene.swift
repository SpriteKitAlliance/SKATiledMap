//
//  GameScene.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        let map = SKATiledMap(mapName: "SampleMapKenny")
        addChild(map)
    
        //showing ease of adding actions to a layer
        let fadeOut = SKAction.fadeAlphaTo(0, duration: 2)
        let fadeIn = SKAction.fadeAlphaTo(1, duration: 2)
        
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        let repeatAction = SKAction.repeatActionForever(sequence)
        
        let backgroundLayer = map.spriteLayers[0]
        backgroundLayer .runAction(repeatAction)
        
        //showing ease of adding action to a specific sprite
        let rotate = SKAction.rotateByAngle(2, duration: 1)
        let repeatRotation = SKAction.repeatActionForever(rotate)
        
        let sprite = map.sprite(2, x: 5, y: 4)
        sprite.runAction(repeatRotation)
        
        let hud = SKATestHud(scene: self, player: SKSpriteNode())
        addChild(hud)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
