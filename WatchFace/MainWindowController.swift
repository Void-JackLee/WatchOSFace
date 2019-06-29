//
//  WindowController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/2/23.
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

import Foundation
import Cocoa
import CoreGraphics

class MainWindowController : NSWindowController
{
    
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var freshButton: NSButton!
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    
    let defaultPath = File(path: "~/SpriteClock")
    
    let item_add = NSTouchBarItem.Identifier(rawValue: "item_theme_add"), item_fresh = NSTouchBarItem.Identifier(rawValue: "item_theme_fresh"), item_expand = NSTouchBarItem.Identifier(rawValue: "item_expand_window")
    let expandButton = NSButton(image: NSImage(named: NSImage.Name("NSGoRightTemplate"))!, target: self, action: #selector(changeSize))
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Set window stuffs
        //window?.isOpaque = false // 不透明
        window?.titleVisibility = .hidden
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        //window?.titlebarAppearsTransparent = true
        window?.title = getString("window_main_title")
        titleLabel.title = getString("window_main_title")
        
        // Receive window transform condition
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: Notification.Name("isOpen"), object: nil) //obj是发送对象
        // Receive fresh list command
        NotificationCenter.default.addObserver(self, selector: #selector(freshList), name: Notification.Name("list_fresh"), object: nil) //obj是发送对象
    }
    
    @objc func change(notification : Notification)
    {
        // Change adding button condition
        let isOpen = notification.object as! Bool
        if isOpen
        {
            window?.toolbar?.insertItem(withItemIdentifier: NSToolbarItem.Identifier("item_fresh"), at: 2)
            window?.toolbar?.insertItem(withItemIdentifier: NSToolbarItem.Identifier("item_add"), at: 3)
            freshList(notification)
            expandButton.image = NSImage(named: NSImage.Name("NSGoLeftTemplate"))!
        } else
        {
            window?.toolbar?.removeItem(at: 2)
            window?.toolbar?.removeItem(at: 2)
            expandButton.image = NSImage(named: NSImage.Name("NSGoRightTemplate"))!
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        // Init folder
        initFiles()
        // Prepare for name adding window
        let addingController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("view_adding")) as! AddNameController
        // Check up whether there has the temporary theme directory
        do {
            let fileList = try defaultPath.list()
            var hasTmp = false
            var tmpName : String?
            for fileName in fileList
            {
                if fileName.hasPrefix("tmp_")
                {
                    hasTmp = true
                    tmpName = fileName
                    break
                }
            }
            if hasTmp
            {
                do
                {
                    // Read theme
                    let theme = try CustomTheme.read(themeDir: self.defaultPath.append(childName: tmpName!))
                    let name = theme.name
                    // Show tip
                    let alert : NSAlert = NSAlert()
                    alert.alertStyle = .informational
                    
                    alert.messageText = "\(getString("message_tmp_1"))\(name)\(getString("message_tmp_2"))"
                    alert.addButton(withTitle: getString("button_continue"))
                    alert.addButton(withTitle: getString("button_create_new_theme"))
                    let type = alert.runModal()
                    if type == .alertSecondButtonReturn
                    {
                        // Create new
                        self.popupAddingNameView(controller: addingController)
                    }
                    if type == .alertFirstButtonReturn
                    {
                        // Continue edit temporary theme, jump to editor
                        addingController.performSegue(withIdentifier: NSStoryboardSegue.Identifier("jump_adding"), sender: theme)
                    }
                } catch
                {
                    print(error)
                    // No temporary theme, create new
                    popupAddingNameView(controller: addingController)
                }
            } else {
                // No temporary theme, create new
                popupAddingNameView(controller: addingController)
            }
        } catch {
            // IOError
            if !defaultPath.isExsits()
            {
                EasyMethod.caughtError(error)
            }
        }
    }
    
    func initFiles()
    {
        do
        {
            // Try to create directory
            let _ = try defaultPath.createDirectory(withIntermediateDirectories: true, attributes: nil)
        }catch
        {
            // IOError
            if !defaultPath.isExsits()
            {
                EasyMethod.caughtError(error)
            }
        }
    }
    
    func popupAddingNameView(controller : AddNameController)
    {
        let popover = NSPopover()
        controller.popover = popover
        popover.contentViewController = controller
        popover.behavior = .transient
        popover.show(relativeTo: addButton.bounds, of: addButton, preferredEdge: NSRectEdge.maxY)
    }
    
    
    @IBAction func freshList(_ sender: Any) {
        (window?.contentViewController as! MainViewController).initData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("isOpen"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("list_fresh"), object: nil)
    }
    
}

@available(OSX 10.12.2, *)
extension MainWindowController : NSTouchBarDelegate
{
    override func makeTouchBar() -> NSTouchBar? {
        let touchbar = NSTouchBar()
        touchbar.customizationIdentifier = NSTouchBar.CustomizationIdentifier("main")
        
        touchbar.defaultItemIdentifiers = [item_expand, item_fresh, item_add]
        touchbar.customizationAllowedItemIdentifiers = [item_expand, item_fresh, item_add]
        
        touchbar.delegate = self
        return touchbar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        var itemDescription = ""
        switch identifier {
        case item_add:
            itemDescription = getString("touchbar_description_fresh_list")
            item.view = NSButton(image: NSImage(named: NSImage.Name("NSAddTemplate"))!, target: self, action: #selector(touchAdd))
        case item_fresh:
            itemDescription = getString("touchbar_description_add")
            item.view = NSButton(image: NSImage(named: NSImage.Name("NSRefreshTemplate"))!, target: self, action: #selector(touchFresh))
        case item_expand:
            itemDescription = getString("touchbar_description_expand")
            item.view = expandButton
        default:
            print("???")
        }
        item.customizationLabel = itemDescription
        return item
    }
    
    @objc func changeSize()
    {
        let viewController = (window!.contentViewController! as! MainViewController)
        let isOpen = viewController.isOpenView
        viewController.changeSize(isOpen: !isOpen)
    }
    
    @objc func touchAdd()
    {
        openExtraWindow()
        addAction(self)
    }
    
    @objc func touchFresh()
    {
        openExtraWindow()
        freshList(self)
    }
    
    func openExtraWindow()
    {
        let viewController = (window!.contentViewController! as! MainViewController)
        if !viewController.isOpenView
        {
            viewController.changeSize(isOpen: true)
        }
    }
    
}
