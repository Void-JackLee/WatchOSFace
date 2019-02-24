//
//  FaceSceneAddition.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/2/24.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import SpriteKit
import GameplayKit

class FaceSceneAddition : FaceScene
{
    var onClick : (() -> Void)?
    private var isMouseDown = false
    
    func setOnClick(onClick : @escaping (() -> Void))
    {
        self.onClick = onClick
    }
    
    override func mouseDown(with event: NSEvent) {
        isMouseDown = true
    }
    
    override func mouseUp(with event: NSEvent) {
        if isMouseDown
        {
            onClick?()
        }
        isMouseDown = false
    }
    
    override func mouseExited(with event: NSEvent) {
        isMouseDown = false
    }
}
