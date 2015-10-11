//
//  GameScene.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKATestPlayer(color: UIColor.blueColor(), size: CGSizeMake(40, 80))
    let map = SKATiledMap(mapName: "SampleMapKenny")
    
    override func didMoveToView(view: SKView) {
        
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
        
        //adding test player
        player.zPosition = 20
        player.position = CGPointMake(400, 400);
        
        map.autoFollowNode = player;
        map.addChild(player)
        
        let hud = SKATestHud(scene: self, player: player)
        addChild(hud)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        map.update()
        player.update()
    }
}
