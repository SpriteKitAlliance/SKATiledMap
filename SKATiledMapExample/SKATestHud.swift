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
   
    init(scene : SKScene, player : SKNode){
    
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
        print(sprite.name)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}