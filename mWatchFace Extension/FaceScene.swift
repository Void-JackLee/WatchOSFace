//
//  GameScene.swift
//  mWatchFace Extension
//
//  Created by Jack Li on 2019/2/13.
//  Copyright © 2019 Jack Li. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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

