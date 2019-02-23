//
//  ViewController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/2/23.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    let skView : SKView = SKView()
    var scene : SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.frame = CGRect(x: 0, y: 0, width: 312, height: 390)
        skView.frame = CGRect(x: 0, y: 0, width: 312, height: 390)
        skView.showsFPS = true
        skView.showsNodeCount = true
        view.addSubview(skView)
        
        scene = FaceScene(size: CGSize(width: 312, height: 390), id: 0xF001)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        /*let btn = NSButton(frame: NSRect(x: 0, y: 0, width: 100, height: 50))
        btn.action = #selector(click)
        view.addSubview(btn)*/
        
    }
    
    /*@objc func click()
    {
        //skView.isPaused = !skView.isPaused
    }*/
    
    override func viewDidAppear() {
        view.window?.styleMask.remove(.resizable)
        view.window?.title = "WatchFace on Mac"
        skView.isPaused = true
        skView.isPaused = false
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

