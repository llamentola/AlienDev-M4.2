//
//  GameScene.swift
//  AlienDev
//
//  Created by Edna Dumas on 3/28/19.
//  Copyright © 2019 Edna Dumas. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var alienDev : SKSpriteNode?
    var lastSpawnTimeInterval : CFTimeInterval?
    var lastUpdateTimeInterval : CFTimeInterval?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.backgroundColor = SKColor.white
        alienDev = SKSpriteNode(imageNamed: "dev")
        alienDev!.position = CGPoint(x:self.frame.midX, y:self.frame.midY); alienDev?.size = CGSize(width:120, height:220)
        self.addChild(alienDev!)
        
        let title = createTextNode(text: "Welcome to Alien Dev",
                nodeName: "titleNode",
                position: CGPoint(x:self.frame.midX, y:self.frame.midY-150))
        self.addChild(title)
    
    }
    
    func createTextNode(text: String, nodeName: String, position: CGPoint) -> SKLabelNode { let labelNode = SKLabelNode(fontNamed: "Futura")
        labelNode.name = nodeName
        labelNode.text = text
        labelNode.fontSize = 30; labelNode.fontColor = SKColor.black;
        labelNode.position = position
        return labelNode
    }
    
    func createBug() {
        let evilBug = SKSpriteNode(imageNamed: "bug")
        evilBug.size = CGSize(width:220, height:120)
        let minX = (evilBug.size.width / 2)
        let maxX = (self.frame.size.width - evilBug.size.width)
        let rangeX : UInt32 = UInt32(maxX - minX)
        let finalX = Int(arc4random() % rangeX) + Int(minX)
        evilBug.position = CGPoint(x:CGFloat(finalX),
                    y:self.frame.size.height + evilBug.size.height/2)
        self.addChild(evilBug)
        let minDuration : Int = 3
        let maxDuration : Int = 8
        let rangeDuration : UInt32 = UInt32(maxDuration - minDuration)
        let finalDuration = Int(arc4random() % rangeDuration) + minDuration
        let actionMove = SKAction.move(to: CGPoint(x:CGFloat(finalX),
                        y:-evilBug.size.height/2), duration:TimeInterval(finalDuration))
        let actionMoveDone = SKAction.removeFromParent()
        evilBug.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLast : CFTimeInterval) {
        if let lastSpawn = lastSpawnTimeInterval {
            lastSpawnTimeInterval! += timeSinceLast
            if (lastSpawnTimeInterval! > 1 ) {
                lastSpawnTimeInterval = 0
                createBug()
            }
        } else {
            lastSpawnTimeInterval = 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let lastUpdate = lastUpdateTimeInterval {
            var timeSinceLast = currentTime - lastUpdate as CFTimeInterval
            lastUpdateTimeInterval = currentTime
            if (timeSinceLast > 1) {
                timeSinceLast = 1.0 / 60.0
                lastUpdateTimeInterval = currentTime
            }
            updateWithTimeSinceLastUpdate(timeSinceLast: timeSinceLast)
        }
        else {
            lastUpdateTimeInterval = currentTime
        }
    }
}
