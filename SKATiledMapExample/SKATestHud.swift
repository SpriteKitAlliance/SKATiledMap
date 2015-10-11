//
//  SKATestHud.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/11/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class SKATestHud : SKNode {
    
    let player : SKATestPlayer
   
    init(scene : SKScene, player : SKATestPlayer){
    
        self.player = player
        
        super.init()
        
        userInteractionEnabled = true
        let padding = 10
        zPosition = 100
        
        //left button
        let leftButton = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(50, 50))
        var x = Int(leftButton.size.width/2) + padding
        var y = Int(leftButton.size.height/2) + padding
        leftButton.position = CGPointMake(CGFloat(x), CGFloat(y))
        leftButton.name = "leftButton"
        addChild(leftButton)
        
        
        //right button
        let rightButton = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(50, 50))
        x = x + Int(rightButton.size.width/2 + leftButton.size.width/2) + (padding * 2)
        y = Int(rightButton.size.height/2) + padding
        rightButton.position = CGPointMake(CGFloat(x), CGFloat(y))
        rightButton.name = "rightButton"
        addChild(rightButton)
        
        //jump button
        let jumpButton = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(50, 50))
        x = Int(scene.view!.frame.size.width)-Int(jumpButton.size.width)-padding
        y = Int(jumpButton.size.height/2) + padding
        jumpButton.position = CGPointMake(CGFloat(x), CGFloat(y))
        jumpButton.name = "jumpButton"
        addChild(jumpButton)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let sprite = nodeAtPoint((touch?.locationInNode(self))!)
        
        if let spriteName = sprite.name {
            
            switch spriteName{
                
                case "leftButton":
                    player.playerState = .Left
                break
                
                case "rightButton":
                    player.playerState = .Right
                break
                
                case "jumpButton" :
                    player.wantsToJump = true
                break
                
                default :
               
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let sprite = nodeAtPoint((touch?.locationInNode(self))!)
        
        if let spriteName = sprite.name {
        
            if (spriteName == "leftButton" && player.playerState == .Left){
                player.playerState = .Idel
            }
            
            if (spriteName == "rightButton" && player.playerState == .Right){
                player.playerState = .Idel
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}