//
//  GameScene.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/5/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
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

import SpriteKit

class GameScene: SKScene {
    
    let player = SKATestPlayer(color: UIColor.blueColor(), size: CGSizeMake(40, 80))
    let map = SKATiledMap(mapName: "SampleMapKenney")
    
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
        
        let sprite = map.spriteFor(2, x: 5, y: 4)
        sprite.runAction(repeatRotation)
        
        //adding test player
        player.zPosition = 20
        player.position = CGPointMake(400, 400);
        
        map.autoFollowNode = player;
        map.addChild(player)
        
        //adding test hud
        let hud = SKATestHud(scene: self, player: player)
        addChild(hud)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
       
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        //updates
        map.update()
        player.update()
        
        //culling feature update
        let playerIndex = map.index(player.position)
        map.cullAround(Int(playerIndex.x), y: Int(playerIndex.y), width: 5, height: 5)

    }
}
