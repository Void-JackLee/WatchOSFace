//
//  AddNameController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/6/16.
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

class AddNameController: NSViewController {

    @IBOutlet weak var scrollerView: NSScrollView!
    @IBOutlet var editText: AddingTextView!
    @IBOutlet weak var titleField: NSTextField!
    
    var popover : NSPopover?
    
    let defaultPath = File(path: "~/SpriteClock")
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        (segue.destinationController as! NSWindowController).prepare(for: segue, sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editText.backgroundColor = .clear
        scrollerView.drawsBackground = false
        scrollerView.backgroundColor = .clear
        editText.font = NSFont.systemFont(ofSize: 13)
        editText.returnAction = {
            self.OKAction(self)
        }
        editText.delegate = self
        editText.cancelAction = { self.popover?.close() }
        
    }
    
    @IBAction func OKAction(_ sender: Any) {
        
        let name = editText.string
        var dirName = name
        if name == ""
        {
            EasyMethod.showAlert(string_empty_name, .critical)
        } else
        {
            if name.contains("/") || name.contains(".") || name.contains("*") || name.contains("?") || name.contains("#")
            {
                EasyMethod.showAlert(string_invalid_name, .critical)
            } else
            {
                if dirName.contains(" ")
                {
                    dirName = dirName.replacingOccurrences(of: " ", with: "_")
                }
                // Create new theme
                do
                {
                    // 1. Delete origin temporary theme directory
                    let _ = try defaultPath.delete(childName: "tmp_*", hasWildcard: true)
                    // 2. Write information.plist
                    let theme = CustomTheme(name: name, time: String(Date().timeIntervalSince1970), rootDir: defaultPath, themeDirName: dirName)
                    try theme.write()
                    // 3. Jump to editor, and send object
                    performSegue(withIdentifier: NSStoryboardSegue.Identifier("jump_adding"), sender: theme)
                } catch
                {
                    EasyMethod.caughtError(error)
                }
            }
        }
        self.dismiss(nil)
    }
}

extension AddNameController : NSTextViewDelegate
{
    func textDidChange(_ notification: Notification) {
        if editText.string == ""
        {
            titleField.placeholderString = NSLocalizedString("string_name", comment: "Name")
        } else
        {
            titleField.placeholderString = ""
        }
    }
}

class AddingTextView : NSTextView
{
    var returnAction : (() -> Void)?
    
    override func insertNewline(_ sender: Any?) {
        returnAction?()
    }
    
    override func insertNewlineIgnoringFieldEditor(_ sender: Any?) {
        returnAction?()
    }
    
    override func paste(_ sender: Any?) {
        
        let pasteboard = NSPasteboard.general
        
        guard let pasteboardItem = pasteboard.pasteboardItems?.first, let text = pasteboardItem.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"))
            else { return }
        
        let cleanText = text.replacingOccurrences(of: "\n", with: " ")
        self.insertText(cleanText, replacementRange: NSRange())
    }
    
    // popover cancel
    var cancelAction : (() -> Void)?
}

extension AddingTextView
{
    override func makeTouchBar() -> NSTouchBar? {
        let touchbar = NSTouchBar()
        touchbar.customizationIdentifier = NSTouchBar.CustomizationIdentifier("addName")
        
        touchbar.defaultItemIdentifiers = [.init("item_OK"), .init("item_Cancel"),.flexibleSpace,.characterPicker]
        touchbar.customizationAllowedItemIdentifiers = [.init("item_OK"), .init("item_Cancel"),.flexibleSpace,.characterPicker]
        
        touchbar.delegate = self
        return touchbar
    }
    
    override func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        var itemDescription = ""
        switch identifier {
        case .init("item_OK"):
            itemDescription = string_touchbar_description_ok
            let button = NSButton(title: string_button_ok, target: self, action: #selector(add))
            button.bezelColor = NSColor.controlAccentColor
            item.view = button
        case .init("item_Cancel"):
            itemDescription = string_touchbar_description_cancel
            item.view = NSButton(title: string_button_cancel, target: self, action: #selector(cancel))
        default:
            print("???")
        }
        item.customizationLabel = itemDescription
        return item
    }
    
    @objc func add()
    {
        returnAction?()
    }
    
    @objc func cancel()
    {
        cancelAction?()
    }
}
