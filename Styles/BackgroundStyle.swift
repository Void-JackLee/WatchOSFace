//
//  BackGroundStyle.swift
//  SpriteWatchInterface
//
//  Created by 李弘辰 on 2019/2/14.
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

import Foundation
import SpriteKit

enum BackgroundStyle
{
    case Particle(String)
    class ParticleFloatingInit
    {
        enum EmitType
        {
            case Floating, Emitter(CGFloat, CGFloat)
        }
        
        let particle = SKEmitterNode()
        private var scene : SKNode
        
        var emitType : EmitType
        {
            didSet
            {
                updateStyle()
            }
        }
        
        convenience init(scene : SKNode, texture : SKTexture, scale : CGFloat, scaleRange : CGFloat) {
            self.init(scene: scene, texture: texture, scale: scale, scaleRange: scaleRange, emitType: .Floating)
        }
        
        init(scene : SKNode, texture : SKTexture, scale : CGFloat, scaleRange : CGFloat, emitType : EmitType) {
            self.scene = scene
            particle.particleTexture = texture
            particle.particleScale = scale
            particle.particleScaleRange = scaleRange
            self.emitType = emitType
            updateStyle()
            initView()
        }
        
        private func initView()
        {
            particle.position = CGPoint(x: 0, y: 0)
            particle.particleBirthRate = 30
            particle.particleLifetime = 2.5
            particle.particleLifetimeRange = 2
            particle.emissionAngle = 0
            particle.emissionAngleRange = CGFloat.pi * 2
            particle.particleSpeed = 100
            particle.particleSpeedRange = 0
            particle.particleScaleSpeed = -0.005
            particle.particleRotationSpeed = 180
            particle.particleColorBlendFactorSpeed = 0.3
            scene.addChild(particle)
        }
        
        private func updateStyle()
        {
            switch emitType {
            case .Floating:
                particle.zPosition = 100
                particle.particlePositionRange = CGVector(dx: 300, dy: 300)
            case .Emitter(let x,let y):
                particle.zPosition = 100
                particle.particlePositionRange = CGVector(dx: x, dy: y)
            }
            
        }
    }
    
    class ParticleStarInit
    {
        
        static func add(scene : SKNode, texture : SKTexture, size : CGSize)
        {
            let particle = SKEmitterNode()
            particle.particleTexture = texture
            particle.particleSize = size
            particle.zPosition = -1
            particle.position = CGPoint(x: -250, y: -250)
            particle.particleBirthRate = 20
            particle.particleLifetime = 100
            particle.particleLifetimeRange = 1
            particle.emissionAngle = CGFloat.pi / 4
            particle.emissionAngleRange = 0
            particle.particleSpeed = 100
            particle.particleSpeedRange = 0
            particle.particleRotation = CGFloat.pi / -4
            particle.particleColorBlendFactorSpeed = 0.125
            particle.particlePositionRange = CGVector(dx: 800, dy: 0)
            scene.addChild(particle)
        }
    }
    
    func addDefaltDial(scene : SKScene) {
        
    }
}
