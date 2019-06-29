//
//  ElementAddingWindowController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/6/23.
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
