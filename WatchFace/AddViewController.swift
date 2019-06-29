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
import SpriteKit

class AddViewController: NSViewController {
    
    @IBOutlet weak var previewHolder: NSView!
    @IBOutlet weak var scrollerView: NSScrollView!
    
    var theme : CustomTheme?
    
    let scene = SKScene(size: CGSize(width: 312, height: 390))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init views
        let elementTableView = NSTableView()
        scrollerView.contentView.documentView = elementTableView
        
        // Set views
        scrollerView.drawsBackground = false
        elementTableView.backgroundColor = NSColor.clear
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("name"))
        column.title = getString("name")
        column.isEditable = false
        column.minWidth = column.width
        elementTableView.addTableColumn(column)
        
        let previewer = SKView()
        previewer.ignoresSiblingOrder = true
        previewer.showsNodeCount = true
        previewer.showsFPS = true
        previewer.allowsTransparency = true
        previewer.presentScene(scene)
        scene.scaleMode = .aspectFit
        
        previewer.translatesAutoresizingMaskIntoConstraints = false
        let MARGIN : CGFloat = 20
        let constraint_left = NSLayoutConstraint(item: previewer, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: previewHolder, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: MARGIN)
        let constraint_top = NSLayoutConstraint(item: previewer, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: previewHolder, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: MARGIN)
        let constraint_right = NSLayoutConstraint(item: previewer, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: previewHolder, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -MARGIN)
        let constraint_bottom = NSLayoutConstraint(item: previewer, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: previewHolder, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -MARGIN)
        
        let constraint_width = NSLayoutConstraint(item: previewer, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 312)
        let constraint_height = NSLayoutConstraint(item: previewer, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 390)
        
        previewHolder.addSubview(previewer)
        previewer.addConstraints([constraint_width, constraint_height])
        previewHolder.addConstraints([constraint_top, constraint_left, constraint_right, constraint_bottom])
    }
    
    override func viewDidAppear() {
        (view.window!.windowController as! AddWindowController).controllerLoaded()
        // Set location
        let WIDTH = view.window!.frame.width
        let HEIGHT = view.window!.frame.height
        let WIDTH_SCREEN = NSScreen.main?.frame.width ?? 0
        let HEIGHT_SCREEN = NSScreen.main?.frame.height ?? 0
        view.window!.setFrame(NSRect(x: (WIDTH_SCREEN - WIDTH) / 2, y: (HEIGHT_SCREEN - HEIGHT) / 2, width: WIDTH, height: HEIGHT), display: true, animate: false)
    }
    
    func openAddingWindow()
    {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("jump_element_adding"), sender: nil)
    }
    
    
}
