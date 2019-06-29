//
//  ViewController.swift
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

import Cocoa
import SpriteKit

class MainViewController: NSViewController, NSWindowDelegate {

    let skView : SKView = SKView()
    var scene : FaceSceneAddition!
    
    let WIDTH_VIEW = 312
    let HEIGHT_VIEW = 390
    
    let WIDTH_EXTRA = 200
    
    var currentX : CGFloat = 0
    var currentY : CGFloat = 0
    
    var isOpenView = false
    
    var titleBarHeight : CGFloat = 0
    
    var data : [String]?
    
    let tableView = NSTableView()
    
    var isInit = true
    
    let defaultPath = File(path: "~/SpriteClock")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set blured background
        let visualEffectView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: WIDTH_VIEW + WIDTH_EXTRA, height: HEIGHT_VIEW))
        visualEffectView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        visualEffectView.state = NSVisualEffectView.State.active
        view.addSubview(visualEffectView)
        
        // Present clock
        skView.frame = CGRect(x: 0, y: 0, width: WIDTH_VIEW, height: HEIGHT_VIEW)
        skView.showsFPS = true
        skView.showsNodeCount = true
        view.addSubview(skView)
        
        scene = FaceSceneAddition(size: CGSize(width: WIDTH_VIEW, height: HEIGHT_VIEW), id: 0xF001)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        // Transform window
        scene.setOnClick {
            self.changeSize(isOpen: !self.isOpenView)
        }
        
        initTableView()
        
    }
    
    override func viewDidAppear() {
        // Calculate the titlebar height
        titleBarHeight = view.window!.frame.height - view.frame.height
        
        // Init window its self
        view.window?.styleMask.remove(.resizable)
        view.window?.delegate = self
        
        // Calulate window size // When the window awake, the size will turn to the first sets, so we need resize it to the right status
        var width = WIDTH_VIEW
        if isOpenView
        {
            width += Int(WIDTH_EXTRA)
        }
        let height = CGFloat(HEIGHT_VIEW) + titleBarHeight
        
        // Center when first appearing
        if isInit
        {
            currentX = ((NSScreen.main?.frame.width ?? 0) - CGFloat(width)) / 2
            currentY = ((NSScreen.main?.frame.height ?? 0) - height) / 2
            isInit = false
        }
        
        // Init the window size
        self.view.window?.setFrame(CGRect(x: currentX, y: currentY, width: CGFloat(width), height: height), display: true, animate: false)
        
        // Awake the scene, it seems stange, but I have to write like this to achieve it
        skView.isPaused = true
        skView.isPaused = false
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // Record the window location
    func windowDidMove(_ notification: Notification) {
        self.currentX = self.view.window?.frame.minX ?? 0
        self.currentY = self.view.window?.frame.minY ?? 0
    }
    
    func changeSize(isOpen : Bool)
    {
        if !isOpen
        {
            currentX = (view.window?.frame.minX ?? 0) + CGFloat(WIDTH_EXTRA) / 2
            currentY = view.window?.frame.minY ?? 0
            view.window?.setFrame(CGRect(x: currentX, y: currentY, width: CGFloat(WIDTH_VIEW), height: CGFloat(HEIGHT_VIEW) + titleBarHeight), display: true, animate: true)
        } else {
            currentX = (view.window?.frame.minX ?? 0) - CGFloat(WIDTH_EXTRA) / 2
            currentY = view.window?.frame.minY ?? 0
            view.window?.setFrame(CGRect(x: currentX, y: currentY, width: CGFloat(WIDTH_VIEW + WIDTH_EXTRA), height: CGFloat(HEIGHT_VIEW) + titleBarHeight), display: true, animate: true)
        }
        isOpenView = !isOpenView
        // Send message to tell window controller update adding button condition
        NotificationCenter.default.post(name: NSNotification.Name("isOpen"), object: isOpenView)
    }
}

// Achieve NSTableView
extension MainViewController : NSTableViewDataSource, NSTableViewDelegate
{
    func initTableView()
    {
        initData()
        
        // Init tableView
        let scrollerView = NSScrollView(frame: NSRect(x: WIDTH_VIEW, y: 0, width: Int(WIDTH_EXTRA), height: HEIGHT_VIEW))
        
        // Add column
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("0"))
        column.title = string_themes
        column.width = scrollerView.frame.width
        column.maxWidth = column.width
        column.minWidth = column.width
        column.isEditable = false
        
        tableView.addTableColumn(column)
        
        // Set delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Make backgrounds clear
        tableView.backgroundColor = NSColor.clear
        scrollerView.drawsBackground = false
        
        // Set tableView
        scrollerView.documentView = tableView
        scrollerView.hasVerticalScroller = true
        view.addSubview(scrollerView)
        
        
    }
    
    func initData()
    {
        // Set test data
        data = CustomTheme.list(rootDir: defaultPath)
        tableView.reloadData()
    }
    
    // Achieve data source
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        //print("\(tableView.editedColumn),\(tableView.editedRow)")
        return data![row]
    }
}



