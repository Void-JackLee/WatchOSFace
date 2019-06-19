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
        column.title = "Name"
        column.isEditable = false
        column.width = scrollerView.frame.width + 100
        column.minWidth = column.width
        
        elementTableView.addTableColumn(column)
    }
    
    override func viewDidAppear() {
        (view.window!.windowController as! AddWindowController).controllerLoaded()
    }
    
    @IBAction func addClick(_ sender: Any) {
        print(Date().timeIntervalSince1970)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        let alert : NSAlert = NSAlert()
        alert.addButton(withTitle: "Back")
        alert.addButton(withTitle: "OK")
        //alert.buttons[1].target = self
        //alert.buttons[1].action = #selector(cancelAdding)
        alert.messageText = "Discard all changes and cancel adding?"
        alert.beginSheetModal(for: view.window!) { (response : NSApplication.ModalResponse) in
            if response ==  NSApplication.ModalResponse.alertSecondButtonReturn
            {
                do
                {
                    try self.theme?.delete()
                } catch { print(error) }
                self.view.window?.close()
            }
        }
    }
    
    
}
