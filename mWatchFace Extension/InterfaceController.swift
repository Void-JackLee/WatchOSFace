//
//  InterfaceController.swift
//  mWatchFace Extension
//
//  Created by Jack Li on 2019/2/13.
//  Copyright © 2019 Jack Li. All rights reserved.
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

import WatchKit
import WatchConnectivity
import Foundation

class TableRowController : NSObject
{
    @IBOutlet weak var interfacePic: WKInterfaceImage!
    
    @IBOutlet weak var interfaceNameTextView: WKInterfaceLabel!
    
}

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    
    @IBAction func showSwitcher() {
        skInterface.setHidden(true)
        interfaceTable.setHidden(false)
    }
    
    var scene : FaceScene?
    let size = CGSize(width: 312, height: 390)
    
    let faces = StyleOrganized.themes
    
    let ducumentPath = NSHomeDirectory() + "/Documents"
    var settingPlist : String?
    let fileManager = FileManager.default
    
    var settings : Dictionary<String, Any>?
    
    var session : WCSession?
    
    func initSettings()
    {
        settingPlist = ducumentPath + "/setting.plist"
        createFile()
        // Read file
        settings = NSDictionary(contentsOfFile: settingPlist!) as? Dictionary<String,Any>
    }
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        initSettings()
        connect()
        // Configure interface objects here.
        
        setScene(id: (settings!["interfaceID_current"] as! Dictionary<String, Int>)["id"]!)
        
        // Use a value that will maintain a consistent frame rate
        self.skInterface.preferredFramesPerSecond = 30
        
        interfaceTable.setNumberOfRows(faces.count, withRowType: "TableRow")
        
        for (index,item) in faces.enumerated()
        {
            let cell = interfaceTable.rowController(at: index) as! TableRowController
            cell.interfacePic.setHeight(contentFrame.width / 2)
            cell.interfacePic.setImage(UIImage(named: item[0] as! String))
            cell.interfaceNameTextView.setText((item[1] as! String))
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        setScene(id: faces[rowIndex][2] as! Int)
        skInterface.setHidden(false)
        interfaceTable.setHidden(true)
        var dict = settings!["interfaceID_current"] as! Dictionary<String, Int>
        dict["id"] = faces[rowIndex][2] as? Int
        dict["time"] = Int(Date().timeIntervalSince1970)
        settings!["interfaceID_current"] = dict
        saveFile()
        sendMessage(session: session!, message: settings!) { (reply : [String : Any]) in }
    }
    
    override func didAppear() {
        HideStatu.hide(self)
        skInterface.setHidden(false)
        interfaceTable.setHidden(true)
    }
    
    func setScene(id : Int)
    {
        scene = FaceScene(size: size, id: id)
        scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene!.scaleMode = .aspectFill
        skInterface.presentScene(scene!)
    }
    
    func updateUI()
    {
        let id = (settings!["interfaceID_current"] as! Dictionary<String, Int>)["id"]!
        if (scene!.currentId != id)
        {
            setScene(id: id)
            skInterface.setHidden(false)
            interfaceTable.setHidden(true)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func connect()
    {
        // Don't need to check isSupport state, because session is always available on WatchOS
        // if WCSession.isSupported() {}
        session = WCSession.default
        session!.delegate = self
        session!.activate()
    }
    
    // Call when data received
    func exchangeData(_ message : [String : Any])
    {
        if let localDataCreateTime = (settings!["interfaceID_current"] as! Dictionary<String, Int>)["time"], let dataReceviedTime = (message["interfaceID_current"] as! Dictionary<String, Int>)["time"]
        {
            if localDataCreateTime < dataReceviedTime
            {
                print("changed!")
                settings = message
                saveFile()
                updateUI()
            }
        }
    }
    
    func doSomethingWhenSessionActive()
    {
        sendMessage(session: session!, message: self.settings!, replyHandler: { (reply : [String : Any]) in
            self.exchangeData(reply)
            print("Succeed_first\(reply)")
        })
    }
    
    // Send
    public func sendMessage(session : WCSession, message : Dictionary<String,Any>, replyHandler : @escaping ([String : Any]) -> Void)
    {
        if (session.isReachable)
        {
            session.sendMessage(message, replyHandler: replyHandler) { (e : Error) in
                print(e)
            }
        } else{
            // Error on Sending
        }
    }
    
    func createFile()
    {
        let isExsit : Bool = fileManager.fileExists(atPath: settingPlist!)
        if !isExsit
        {
            let time : Int = Int(Date().timeIntervalSince1970)
            let firstDict : NSDictionary = ["interfaceID_current" : ["id" : 0xF001,
                                                                     "time" : time]]
            firstDict.write(toFile: settingPlist!, atomically: true)
        }
    }
    
    func saveFile()
    {
        (self.settings! as NSDictionary).write(toFile: self.settingPlist!, atomically: true)
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        doSomethingWhenSessionActive()
    }
    
    // Receive
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        exchangeData(message)
        replyHandler(settings!)
        //replyHandler(["reply":"I received your message"])
    }
}


