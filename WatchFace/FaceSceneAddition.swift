//
//  FaceSceneAddition.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/2/24.
//  Copyright © 2019 李弘辰. All rights reserved.
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
