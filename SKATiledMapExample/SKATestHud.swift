//
//  SKATestHud.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/11/15.
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