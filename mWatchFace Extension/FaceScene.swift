//
//  GameScene.swift
//  mWatchFace Extension
//
//  Created by Jack Li on 2019/2/13.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import SpriteKit

class FaceScene: SKScene {
    
    var style : StyleOrganized?
    var currentId : Int = 0xF001
    
    override func sceneDidLoad() {
        
    }
    
    public func presentFace(id : Int)
    {
        removeAllChildren()
        switch id {
        case 0xF001:
            style = StyleOrganized(scene: self, foregroundStyle: .Basic("regular"), backgroundStyle: .Particle("heart"))
            currentId = id
        case 0xF002:
            style = StyleOrganized(scene: self, foregroundStyle: .Basic("regular"), backgroundStyle: .Particle("star"))
            currentId = id
        default:
            style = StyleOrganized(scene: self, foregroundStyle: .Basic("regular"), backgroundStyle: .Particle("heart"))
            currentId = 0xF001
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        style?.update()
    }
    
    
}

