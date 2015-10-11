//
//  SKATestPlayer.swift
//  SKATiledMapExample
//
//  Created by Skyler Lauren on 10/11/15.
//  Copyright © 2015 Sprite Kit Alliance. All rights reserved.
//

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