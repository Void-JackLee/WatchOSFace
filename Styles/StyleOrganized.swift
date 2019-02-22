//
//  StyleOrganized.swift
//  SpriteWatchInterface
//
//  Created by Jack Li on 2019/2/15.
//  Copyright © 2019 Jack Li. All rights reserved.
//

import Foundation
import SpriteKit

class StyleOrganized
{
    
    static let themes = [["face_heart","Heart",0xF001],["face_star","Star",0xF002]]
    
    var scene : SKNode
    
    var foregroundStyle : HandStyle
    var backgroundStyle : BackgroundStyle
    
    var basicForeground : HandStyle.BasicInit?
    
    init(scene : SKNode, foregroundStyle : HandStyle, backgroundStyle : BackgroundStyle) {
        self.scene = scene
        self.foregroundStyle = foregroundStyle
        self.backgroundStyle = backgroundStyle
        initForeground()
        initBackground()
    }
    
    private func initForeground()
    {
        func initRegularBasic()
        {
            
            let hourHand = SKSpriteNode(imageNamed: "Hour_Hand-shadow")
            let minuteHand = SKSpriteNode(imageNamed: "Minute_Hand-shadow")
            let secondHand = SKSpriteNode(imageNamed: "Second_Hand-shadow")
            
            hourHand.zPosition = 1
            minuteHand.zPosition = 2
            secondHand.zPosition = 3
            
            // Init the hands
            secondHand.anchorPoint = CGPoint(x: 0.5, y: 25.5 / secondHand.size.height)
            minuteHand.anchorPoint = CGPoint(x: 0.5, y: 7.5 / minuteHand.size.height)
            hourHand.anchorPoint = CGPoint(x: 0.5, y: 7.5 / hourHand.size.height)
            
            
            
            basicForeground = HandStyle.BasicInit(scene, hourHandNode: hourHand, minuteHandNode: minuteHand, secondHandNode: secondHand)
        }
        
        switch foregroundStyle {
        case .Basic("regular"):
            initRegularBasic()
        default:
            initRegularBasic()
        }
    }
    
    private func initBackground()
    {
        func initHeart()
        {
            let _ = BackgroundStyle.ParticleFloatingInit(scene: scene, texture: SKTexture(imageNamed: "heart"), scale: 0.03, scaleRange: 0.01)
            // Init the background
            let backgroundPic = SKSpriteNode(imageNamed: "S4Numbers")
            backgroundPic.position = CGPoint(x: 0, y: 0)
            backgroundPic.setScale(0.8)
            scene.addChild(backgroundPic)
            
            let back = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize(width: scene.frame.width, height: scene.frame.height))
            back.zPosition = -2
            scene.addChild(back)
        }
        
        func initStar()
        {
            BackgroundStyle.ParticleStarInit.add(scene: scene, texture: SKTexture(imageNamed: "dot"), size: CGSize(width: 1, height: 100))
            
            let back = SKSpriteNode(imageNamed: "stars")
            back.scale(to: CGSize(width: scene.frame.width, height: scene.frame.height))
            back.zPosition = -2
            scene.addChild(back)
            
            // Init the background
            let backgroundPic = SKSpriteNode(imageNamed: "S4Numbers")
            backgroundPic.position = CGPoint(x: 0, y: 0)
            backgroundPic.setScale(0.8)
            scene.addChild(backgroundPic)
        }
        
        switch backgroundStyle {
        case .Particle("heart"):
            initHeart()
        case .Particle("star"):
            initStar()
        default :
            initHeart()
        }
    }
    
    public func update()
    {
        switch foregroundStyle {
        case .Basic:
            basicForeground?.update()
        }
    }
}
