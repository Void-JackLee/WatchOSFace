//
//  ViewController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/2/23.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController, NSWindowDelegate {

    let skView : SKView = SKView()
    var scene : FaceSceneAddition!
    
    let WIDTH_WINDOW = 312
    let HEIGHT_WINDOW = 390
    
    var currentX = (NSScreen.main?.frame.width ?? 0) / 2 - CGFloat(312 / 2)
    var currentY = (NSScreen.main?.frame.height ?? 0) / 2 - CGFloat(290 / 2)
    
    
    var isOpenView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        skView.frame = CGRect(x: 0, y: 0, width: WIDTH_WINDOW, height: HEIGHT_WINDOW)
        skView.showsFPS = true
        skView.showsNodeCount = true
        view.addSubview(skView)
        
        scene = FaceSceneAddition(size: CGSize(width: WIDTH_WINDOW, height: HEIGHT_WINDOW), id: 0xF001)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        scene.setOnClick {
            if self.isOpenView
            {
                self.currentX = (self.view.window?.frame.minX ?? 0) + 200
                self.currentY = self.view.window?.frame.minY ?? 0
                self.view.window?.setFrame(CGRect(x: self.currentX, y: self.currentY, width: CGFloat(self.WIDTH_WINDOW), height: CGFloat(self.HEIGHT_WINDOW)), display: true, animate: true)
            } else{
                self.currentX = (self.view.window?.frame.minX ?? 0) - 200
                self.currentY = self.view.window?.frame.minY ?? 0
                self.view.window?.setFrame(CGRect(x: self.currentX, y: self.currentY, width: CGFloat(self.WIDTH_WINDOW) + 400, height: CGFloat(self.HEIGHT_WINDOW)), display: true, animate: true)
            }
            self.isOpenView = !self.isOpenView
        }
        
        let tableView = NSTableView(frame: NSRect(x: WIDTH_WINDOW, y: 0, width: 400, height: HEIGHT_WINDOW))
        view.addSubview(tableView)
        
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
        view.window?.delegate = self
        var width = WIDTH_WINDOW
        if isOpenView
        {
            width += 400
        }
        self.view.window?.setFrame(CGRect(x: currentX, y: currentY, width: CGFloat(width), height: CGFloat(HEIGHT_WINDOW)), display: true, animate: false)
        skView.isPaused = true
        skView.isPaused = false
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func windowDidMove(_ notification: Notification) {
        self.currentX = self.view.window?.frame.minX ?? 0
        self.currentY = self.view.window?.frame.minY ?? 0
    }
}

