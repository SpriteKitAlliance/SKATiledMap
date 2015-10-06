//
//  SKATestPlayer.swift
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

enum SKAPlayerState {
    case Idel
    case Left
    case Right
}

class SKATestPlayer : SKSpriteNode {
    
    var wantsToJump = false
    var playerState : SKAPlayerState = .Idel
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        loadAssets()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        
        switch playerState{
        case .Right :
            runRight()
            break
        case .Left :
            runLeft()
            break
        case .Idel :
            break
        }
        
        if (wantsToJump && physicsBody?.velocity.dy == 0){
            jump()
        }
    }
    
    func runRight(){
        physicsBody?.velocity = CGVectorMake(170, (physicsBody?.velocity.dy)!);
    }
    
    func runLeft(){
        physicsBody?.velocity = CGVectorMake(-170, (physicsBody?.velocity.dy)!);
    }
    
    func jump(){
        wantsToJump = false
        physicsBody?.velocity = CGVectorMake((physicsBody?.velocity.dx)!, 800);
    }
    
    func loadAssets(){
        position = CGPointMake(300, 500)
        physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPointMake(0, -40))
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
        physicsBody?.friction = 0.2
        physicsBody?.mass = 10
        physicsBody?.affectedByGravity = true
        
        physicsBody!.categoryBitMask = SKAColliderType.Player.rawValue
        physicsBody!.collisionBitMask = SKAColliderType.Floor.rawValue | SKAColliderType.Wall.rawValue
        physicsBody!.contactTestBitMask = SKAColliderType.Floor.rawValue | SKAColliderType.Wall.rawValue
    }
}