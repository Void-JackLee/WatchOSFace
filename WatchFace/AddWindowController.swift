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
    
    let item_add = NSTouchBarItem.Identifier("item_element_add"), item_remove = NSTouchBarItem.Identifier("item_element_remove"), item_confirm = NSTouchBarItem.Identifier("item_create_confirm"), item_cancel = NSTouchBarItem.Identifier("item_create_cancel")
    
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        theme = sender as? CustomTheme
        window?.title = string_window_theme_add_title + " - " + theme!.name
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
        window?.title = string_window_theme_add_title
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        
        
    }
    
    @IBAction func addElementAction(_ sender: Any) {
        (contentViewController as? AddViewController)?.openAddingWindow()
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
        alert.addButton(withTitle: string_button_back)
        alert.addButton(withTitle: string_button_ok)
        //alert.buttons[1].target = self
        //alert.buttons[1].action = #selector(cancelAdding)
        alert.messageText = string_message_discard_change
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
        
        touchbar.defaultItemIdentifiers = [item_add, item_remove, .flexibleSpace ,item_cancel, item_confirm]
        touchbar.customizationAllowedItemIdentifiers = [item_add, item_remove, .flexibleSpace, item_cancel, item_confirm]
        
        touchbar.delegate = self
        return touchbar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        var itemDescription = ""
        switch identifier {
        case item_add:
            itemDescription = string_touchbar_description_element_add
            item.view = NSButton(image: NSImage(named: NSImage.Name("NSAddTemplate"))!, target: self, action: #selector(addElementAction))
        case item_remove:
            itemDescription = string_touchbar_description_element_remove
            item.view = NSButton(image: NSImage(named: NSImage.Name("NSTrashEmpty"))!, target: self, action: nil)
        case item_confirm:
            itemDescription = string_touchbar_description_theme_confirm
            item.view = NSButton(image: NSImage(named: NSImage.Name("progresshud-success"))!, target: self, action: #selector(confirmClick))
        case item_cancel:
            itemDescription = string_touchbar_description_theme_edit_cancel
            item.view = NSButton(image: NSImage(named: NSImage.Name("progresshud-error"))!, target: self, action: #selector(cancelClick))
        default:
            print("???")
        }
        
        item.customizationLabel = itemDescription
        return item
    }
}
