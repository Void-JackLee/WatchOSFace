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

    @IBOutlet weak var titleField: NSTextField!
    
    let defaultPath = File(path: "~/SpriteClock")
    //let fileManager = FileManager.default
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        (segue.destinationController as! NSWindowController).prepare(for: segue, sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func OKAction(_ sender: Any) {
        
        let name = titleField.stringValue
        if name == ""
        {
            EasyMethod.showAlert("Name can't be empty!", .critical)
        } else
        {
            if name.contains(" ") || name.contains("/") || name.contains(".") || name.contains("*") || name.contains("?") || name.contains("#")
            {
                EasyMethod.showAlert("Name can't contain \" \", ?, *, #, . or /", .critical)
            } else
            {
                // Create new theme
                do
                {
                    // 1. Delete origin temporary theme directory
                    let _ = try defaultPath.delete(childName: "tmp_*", hasWildcard: true)
                    // 2. Write information.plist
                    let theme = CustomTheme(name: name, time: String(Date().timeIntervalSince1970), rootDir: defaultPath)
                    try theme.write(isFirstTmp: true)
                    // 3. Jump to editor, and send object
                    performSegue(withIdentifier: NSStoryboardSegue.Identifier("jump_element_adding"), sender: theme)
                } catch
                {
                    EasyMethod.caughtError(error)
                }
            }
        }
        self.dismiss(nil)
    }
}
