//
//  AddViewController.swift
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

class AddViewController: NSViewController {
    
    @IBOutlet weak var previewHolder: NSView!
    @IBOutlet weak var scrollerView: NSScrollView!
    
    var theme : CustomTheme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init views
        let elementTableView = NSTableView()
        scrollerView.contentView.documentView = elementTableView
        
        // Set views
        scrollerView.drawsBackground = false
        elementTableView.backgroundColor = NSColor.clear
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        column.title = NSLocalizedString("string_name", comment: "Name")
        column.isEditable = false
        //column.width = scrollerView.frame.width + 100
        column.minWidth = column.width
        
        elementTableView.addTableColumn(column)
    }
    
    override func viewDidAppear() {
        (view.window!.windowController as! AddWindowController).controllerLoaded()
    }
    
    func openAddingWindow()
    {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("jump_element_adding"), sender: nil)
    }
    
    
}
