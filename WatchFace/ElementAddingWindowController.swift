//
//  ElementAddingWindowController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/6/23.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import Cocoa

class ElementAddingWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        window!.delegate = self
        let panel = window as! NSPanel
        panel.styleMask = [.hudWindow, .titled, .fullSizeContentView]
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.titleVisibility = .hidden
        center()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowDidResignKey(_ notification: Notification) {
        close()
    }
    
    func center()
    {
        let frame = window!.frame
        window!.setFrame(NSRect(x: ((NSScreen.main?.frame.width ?? 0) - frame.width) / 2, y: ((NSScreen.main?.frame.height ?? 0) - frame.height) / 2, width: frame.width, height: frame.height), display: true, animate: false)
    }
}
