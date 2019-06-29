//
//  ElementAddingViewController.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/6/15.
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

class ElementAddingViewController: NSViewController {

    @IBOutlet weak var scrollerView: NSScrollView!
    
    let HEIGHT : CGFloat = 60
    let margin_left : CGFloat = 16
    let margin_top : CGFloat = 5
    
    let types = [["ColoredSprite_48", getString("node_color_sprite_name"), getString("node_color_sprite_description")], ["EmptyNode48", getString("node_empty_name"), getString("node_empty_description")], ["Emitter_48", getString("node_emitter_name"), getString("node_emitter_description")],  ["Label_48", getString("node_label_name"), getString("node_label_description")]]
    
    var scene : SKScene?
    
    @IBOutlet weak var previewContainer: NSView!
    @IBOutlet weak var informationContainer: NSView!
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var textViewContainer: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setTableView()
        
        if scene == nil
        {
            scene = SKScene(size: CGSize(width: previewContainer.frame.width, height: previewContainer.frame.height))
            scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        let mSKView = SKView(frame: NSRect(x: 0, y: 0, width: previewContainer.frame.width, height: previewContainer.frame.height))
        scene?.scaleMode = .aspectFill
        scene?.backgroundColor = NSColor.clear
        mSKView.allowsTransparency = true
        mSKView.presentScene(scene)
        mSKView.ignoresSiblingOrder = true
        mSKView.showsFPS = true
        previewContainer.addSubview(mSKView)
        
        textViewContainer.backgroundColor = NSColor.clear
        textViewContainer.drawsBackground = false
        descriptionTextView.backgroundColor = NSColor.clear
        descriptionTextView.font = NSFont.systemFont(ofSize: 13)
        descriptionTextView.isEditable = false
    }
    
    func addTo(index : Int)
    {
        
    }
    
    func selected(index : Int)
    {
        if scene == nil
        {
            scene = SKScene(size: CGSize(width: previewContainer.frame.width, height: previewContainer.frame.height))
            scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        switch index {
        case 0:
            scene!.removeAllChildren()
            let spriteNode = SKSpriteNode(imageNamed: types[0][0])
            scene!.addChild(spriteNode)
            descriptionTextView.string = types[0][2]
        case 1:
            scene!.removeAllChildren()
            descriptionTextView.string = types[1][2]
        case 2:
            scene!.removeAllChildren()
            let emitterNode = SKEmitterNode()
            emitterNode.particleTexture = SKTexture(imageNamed: "dot") //粒子图片
            emitterNode.particleSize =  CGSize(width: 1, height: 1) //粒子大小
            emitterNode.position = CGPoint(x: 0, y: 0) //粒子发射器的位置
            emitterNode.particleBirthRate = 100 //粒子出生率
            emitterNode.particleLifetime = 3 //粒子生命时长
            emitterNode.particleLifetimeRange = 0 //粒子生命时长范围
            emitterNode.emissionAngle = 0 //初始发射角度
            emitterNode.emissionAngleRange = CGFloat.pi * 2 //发射角度范围
            emitterNode.particleSpeed = 50 //速度
            emitterNode.particleSpeedRange = 0 //速度范围
            emitterNode.particleColorBlendFactorSpeed = 0.125 //消亡速度
            emitterNode.particlePositionRange = CGVector(dx: 0, dy: 0) // 出生位置范围（相对于例子发射器±dx ±dy）
            scene!.addChild(emitterNode)
            descriptionTextView.string = types[2][2]
        case 3:
            scene!.removeAllChildren()
            let labelNode = SKLabelNode()
            labelNode.text = "Hello World!"
            labelNode.fontColor = NSColor.white
            labelNode.fontSize = 40
            scene!.addChild(labelNode)
            descriptionTextView.string = types[3][2]
            
        default:
            let _ : Int8 = 0
        }
    }
    
}

extension ElementAddingViewController : NSTableViewDelegate, NSTableViewDataSource
{
    func setTableView()
    {
        let tableView = NSTableView()
        tableView.headerView = nil
        scrollerView.documentView = tableView
        tableView.frame = NSRect(x: 0, y: 0, width: scrollerView.frame.width, height: tableView.frame.height)
        
        // Add column
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("type_elements"))
        column.isEditable = false
        column.width = scrollerView.frame.width
        
        tableView.addTableColumn(column)
        tableView.rowHeight = HEIGHT
        
        // Set delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Make backgrounds clear
        tableView.backgroundColor = NSColor.clear
        scrollerView.drawsBackground = false
        
        // Stuffs
        tableView.selectRowIndexes(IndexSet(arrayLiteral: 0), byExtendingSelection: false)
        
        tableView.doubleAction = #selector(doubleClick)
        
    }
    
    @objc func doubleClick(_ sender : Any?)
    {
        let index = (sender as! NSTableView).selectedRow
        if index > -1
        {
            addTo(index: index)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let length = HEIGHT - margin_top * 2
        
        let view = NSView(frame: NSRect(x: 0, y: 0, width: tableView.frame.width, height: HEIGHT))
        
        let imageView = NSImageView(frame: NSRect(x: margin_left, y: margin_top, width: length, height: length))
        imageView.image = NSImage(named: NSImage.Name(types[row][0]))
        
        
        let textViewContainer = NSView(frame: NSRect(x: margin_left + length + margin_top, y: 0, width: tableView.frame.width - (margin_left + length + margin_top), height: HEIGHT))
        let textView = NSTextField(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        textView.drawsBackground = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.isBordered = false
        textView.stringValue = types[row][1]
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint_center_vertical = NSLayoutConstraint(item: textView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textViewContainer, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0)
        let constraint_left = NSLayoutConstraint(item: textView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textViewContainer, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 8)
        
        textViewContainer.addConstraint(constraint_left)
        textViewContainer.addConstraint(constraint_center_vertical)
        
        textViewContainer.addSubview(textView)
        view.addSubview(textViewContainer)
        view.addSubview(imageView)
        
        return view
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        selected(index: (notification.object as! NSTableView).selectedRow)
    }
    
    /*func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        selected(index : proposedSelectionIndexes.first!)
        return proposedSelectionIndexes
    }*/
    
    
}
