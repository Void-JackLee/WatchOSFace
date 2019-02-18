//
//  HandInterface.swift
//  SpriteWatchInterface
//
//  Created by 李弘辰 on 2019/2/14.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import Foundation
import SpriteKit

enum HandStyle
{
    case Basic(String)
    class BasicInit
    {
        public var isScreenShots = false
        
        private var scene : SKNode!
        
        private let secondHand : SKSpriteNode
        private let minuteHand : SKSpriteNode
        private let hourHand : SKSpriteNode
        
        private let pi = CGFloat(Double.pi)
        private let LENGTH_NANOSECOND : Double = 1000000000
        
        init(_ scene : SKNode, hourHandNode : SKSpriteNode, minuteHandNode : SKSpriteNode, secondHandNode : SKSpriteNode)
        {
            self.scene = scene
            self.hourHand = hourHandNode
            self.minuteHand = minuteHandNode
            self.secondHand = secondHandNode
            initViews()
        }
        
        
        private func initViews()
        {
            secondHand.position = CGPoint(x: 0, y: 0)
            scene.addChild(secondHand)
            
            minuteHand.position = CGPoint(x: 0, y: 0)
            scene.addChild(minuteHand)
            
            hourHand.position = CGPoint(x: 0, y: 0)
            scene.addChild(hourHand)
        }
        
        // Deprecated
        private func initActions()
        {
            let secondActionSingle = SKAction.rotate(byAngle: CGFloat(Double.pi) * -2, duration: 60)
            let minuteActionSingle = SKAction.rotate(byAngle: CGFloat(Double.pi) * -2, duration: 3600)
            let hourActionSingle = SKAction.rotate(byAngle: CGFloat(Double.pi) * -2, duration: 3600 * 12)
            
            let secondAction = SKAction.repeatForever(secondActionSingle)
            let minuteAction = SKAction.repeatForever(minuteActionSingle)
            let hourAction = SKAction.repeatForever(hourActionSingle)
            
            secondHand.run(secondAction)
            minuteHand.run(minuteAction)
            hourHand.run(hourAction)
        }
        
        private func setAngle(hour : CGFloat, minute : CGFloat, second : CGFloat)
        {
            let s = second * pi * -2 / 60
            let m = minute * pi * -2 / 60 + second / 60 * (pi * -2 / 60)
            let h = hour * pi * -2 / 12 + minute / 60 * (pi * -2 / 12) + second / 60 * (pi * -2 / (12 * 60))
            secondHand.zRotation = s
            minuteHand.zRotation = m
            hourHand.zRotation = h
            //print("-- rotation --\n\((h / CGFloat(pi) * 180).truncatingRemainder(dividingBy: 360)):\(m / CGFloat(pi) * 180):\(s / CGFloat(pi) * 180)")
        }
        
        private func getTime() -> (year : Int, mounth : Int, day : Int, hour : CGFloat, minute : CGFloat, second : CGFloat)
        {
            let now = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy"
            let year = Int(dateformatter.string(from: now))!
            dateformatter.dateFormat = "MM"
            let mounth = Int(dateformatter.string(from: now))!
            dateformatter.dateFormat = "dd"
            let day = Int(dateformatter.string(from: now))!
            dateformatter.dateFormat = "HH"
            
            /*let hour = Int(dateformatter.string(from: now))!
             dateformatter.dateFormat = "mm"
             let minute = Int(dateformatter.string(from: now))!
             dateformatter.dateFormat = "ss"
             
             let timeInterval: TimeInterval = now.timeIntervalSince1970
             var second : Double = timeInterval
             second = second - Double(Int(second)) + Double(dateformatter.string(from: now))!*/
            
            let calendar = Calendar.current
            let dateComponent = calendar.dateComponents([Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second,Calendar.Component.nanosecond], from: now)
            
            var hour = CGFloat(dateComponent.hour!)
            var minute = CGFloat(dateComponent.minute!)
            var second = CGFloat(Double(dateComponent.second!) + Double(dateComponent.nanosecond!) / LENGTH_NANOSECOND)
            if isScreenShots
            {
                hour = 10
                minute = 9
                second = 30
            }
            
            
            return (year, mounth, day, CGFloat(hour), CGFloat(minute), CGFloat(second))
        }
        
        private func fresh()
        {
            let time = getTime()
            setAngle(hour: time.hour, minute: time.minute, second: time.second)
        }
        
        public func update()
        {
            fresh()
        }
    }
}
