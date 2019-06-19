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
    @IBOutlet weak var addButton: NSButtonCell!
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    
    let defaultPath = File(path: "~/SpriteClock")
    
    var buttonImage : NSImage?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Set window stuffs
        //window?.isOpaque = false // 不透明
        window?.titleVisibility = .hidden
        window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        //window?.titlebarAppearsTransparent = true
        titleLabel.title = "WatchFace on Mac"
        
        // Init adding button condition
        buttonImage = addButton.image
        addButton.image = nil
        addButton.isBordered = false
        addButton.isEnabled = false
        
        // Receive window transform condition
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: Notification.Name("isOpen"), object: nil) //obj是发送对象
    }
    
    @objc func change(notification : Notification)
    {
        // Change adding button condition
        let isOpen = notification.object as! Bool
        addButton.isEnabled = isOpen
        if isOpen
        {
            addButton.image = buttonImage
            addButton.isBordered = true
        }else{
            addButton.image = nil
            addButton.isBordered = false
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
                var has_ = false
                var i = 0
                for c in tmpName!
                {
                    if c == "_"
                    {
                        if !has_
                        {
                            has_ = true
                        } else
                        {
                            break
                        }
                    }
                    i = i + 1
                }
                let name = String(tmpName!.suffix(tmpName!.count - i - 1))
                // Show tip
                let alert : NSAlert = NSAlert()
                alert.alertStyle = .informational
                alert.messageText = "Found unsaved theme \"\(name)\", do you want to continue your work?"
                alert.addButton(withTitle: "Continue")
                alert.addButton(withTitle: "Create new theme")
                let type = alert.runModal()
                if type == .alertSecondButtonReturn
                {
                    // Create new
                    self.popupAddingNameView(controller: addingController)
                }
                if type == .alertFirstButtonReturn
                {
                    do
                    {
                        // Read theme
                        let theme = try CustomTheme.read(themeDir: self.defaultPath.append(childName: tmpName!))
                        // Continue edit temporary theme, jump to editor
                        addingController.performSegue(withIdentifier: NSStoryboardSegue.Identifier("jump_element_adding"), sender: theme)
                    } catch
                    {
                        if let e = error as? ThemeError
                        {
                            switch e {
                            case .DirectoryError:
                                EasyMethod.showAlert("Something wrong with theme directory.", .critical)
                            case .InformationFileError:
                                EasyMethod.showAlert("Theme's information.plist has some problems.", .critical)
                            case .FileNotFound:
                                EasyMethod.showAlert("\"\(tmpName!)\" Not found!", .critical)
                            default:
                                EasyMethod.caughtError(error)
                            }
                        } else { EasyMethod.caughtError(error) }
                    }
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
    
    func popupAddingNameView(controller : NSViewController)
    {
        let popover = NSPopover()
        popover.contentViewController = controller
        popover.behavior = .transient
        popover.show(relativeTo: addButton.controlView!.bounds, of: addButton.controlView!, preferredEdge: NSRectEdge.maxY)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("isOpen"), object: nil)
    }
    
}
