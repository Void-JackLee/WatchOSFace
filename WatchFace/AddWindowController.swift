//
//  AddWindowController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/6/14.
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

class AddWindowController: NSWindowController {
    
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    
    @IBOutlet weak var addButton: NSButton!
    
    var hasError = false
    
    var theme : CustomTheme?
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        theme = sender as? CustomTheme
        window?.title = "Add New Theme - " + theme!.name
        titleLabel.title = window!.title
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Set location
        let WIDTH = window!.frame.width
        let HEIGHT = window!.frame.height
        let WIDTH_SCREEN = NSScreen.main?.frame.width ?? 0
        let HEIGHT_SCREEN = NSScreen.main?.frame.height ?? 0
        window!.setFrame(NSRect(x: (WIDTH_SCREEN - WIDTH) / 2, y: (HEIGHT_SCREEN - HEIGHT) / 2, width: WIDTH, height: HEIGHT), display: true, animate: false)
        
        // Set stuff
        window?.title = "Add New Theme"
        titleLabel.title = window!.title
        window?.titleVisibility = .hidden
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        
        
    }
    
    @IBAction func addElementAction(_ sender: Any) {
        let addingController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("controller_adding")) as! ElementAddingViewController
        let popover = NSPopover()
        popover.contentViewController = addingController
        popover.behavior = .transient
        popover.show(relativeTo: addButton.frame, of: addButton, preferredEdge: NSRectEdge.maxY)
    }
    
    func controllerLoaded()
    {
        (contentViewController as! AddViewController).theme = theme!
    }
    
    func readDir(_ path : String)
    {
        
    }
}
