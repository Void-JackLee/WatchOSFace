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
    
    convenience init(size: CGSize, id : Int) {
        self.init(size: size)
        currentId = id
        presentFace()
    }
    
    
    override func sceneDidLoad() {
        
    }
    
    public func presentFace()
    {
        switch currentId {
        case 0xF001:
            style = StyleOrganized(scene: self, foregroundStyle: .Basic("regular"), backgroundStyle: .Particle("heart"))
        case 0xF002:
            style = StyleOrganized(scene: self, foregroundStyle: .Basic("regular"), backgroundStyle: .Particle("star"))
        default:
            style = StyleOrganized(scene: self, foregroundStyle: .Basic("regular"), backgroundStyle: .Particle("heart"))
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        style?.update()
    }
    
    
}

