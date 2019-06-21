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
    
    @IBOutlet weak var addButton: NSButton!
    
    var hasError = false
    
    var theme : CustomTheme?
    
    let item_add = NSTouchBarItem.Identifier(rawValue: "item_element_add"), item_remove = NSTouchBarItem.Identifier(rawValue: "item_element_remove"), item_confirm = NSTouchBarItem.Identifier(rawValue: "item_create_confirm"), item_cancel = NSTouchBarItem.Identifier(rawValue: "item_create_cancel")
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        theme = sender as? CustomTheme
        window?.title = "Add New Theme - " + theme!.name
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
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        
        
    }
    
    @IBAction func addElementAction(_ sender: Any) {
        let addingController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("controller_adding")) as! ElementAddingViewController
        let popover = NSPopover()
        popover.contentViewController = addingController
        popover.behavior = .transient
        popover.show(relativeTo: addButton.frame, of: addButton, preferredEdge: NSRectEdge.maxY)
    }
    
    
    @IBAction func confirmClick(_ sender: Any) {
        do
        {
            try theme?.commit()
            // Send message to tell main window controller update list
            NotificationCenter.default.post(name: NSNotification.Name("list_fresh"), object: nil)
            window!.close()
        } catch {
            EasyMethod.caughtError(error)
        }
    }
    
    
    @IBAction func cancelClick(_ sender: Any) {
        let alert : NSAlert = NSAlert()
        alert.addButton(withTitle: "Back")
        alert.addButton(withTitle: "OK")
        //alert.buttons[1].target = self
        //alert.buttons[1].action = #selector(cancelAdding)
        alert.messageText = "Discard all changes and cancel adding?"
        alert.beginSheetModal(for: window!) { (response : NSApplication.ModalResponse) in
            if response ==  NSApplication.ModalResponse.alertSecondButtonReturn
            {
                do
                {
                    if self.theme != nil
                    {
                        if self.theme!.isFirstTmp { try self.theme!.delete() }
                        else
                        {
                            //删掉.tmp文件
                        }
                    }
                } catch { print(error) }
                self.window?.close()
            }
        }
    }
    
    func controllerLoaded()
    {
        (contentViewController as! AddViewController).theme = theme!
    }
}

extension AddWindowController : NSTouchBarDelegate
{
    override func makeTouchBar() -> NSTouchBar? {
        let touchbar = NSTouchBar()
        touchbar.customizationIdentifier = NSTouchBar.CustomizationIdentifier("editor")
        
        touchbar.defaultItemIdentifiers = [item_add, item_remove, .flexibleSpace ,item_confirm, item_cancel]
        touchbar.customizationAllowedItemIdentifiers = [item_add, item_remove, .flexibleSpace, item_confirm, item_cancel]
        
        touchbar.delegate = self
        return touchbar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        var itemDescription = ""
        switch identifier {
        case item_add:
            itemDescription = "Add Element Button"
            item.view = NSButton(image: NSImage(named: NSImage.Name("NSAddTemplate"))!, target: self, action: #selector(addElementAction))
        case item_remove:
            itemDescription = "Remove Element Button"
            item.view = NSButton(image: NSImage(named: NSImage.Name("NSTrashEmpty"))!, target: self, action: nil)
        case item_confirm:
            itemDescription = "Confirm Theme Button"
            item.view = NSButton(image: NSImage(named: NSImage.Name("progresshud-success"))!, target: self, action: #selector(confirmClick))
        case item_cancel:
            itemDescription = "Cancel Edit Theme Button"
            item.view = NSButton(image: NSImage(named: NSImage.Name("progresshud-error"))!, target: self, action: #selector(cancelClick))
        default:
            print("???")
        }
        
        item.customizationLabel = itemDescription
        return item
    }
}
