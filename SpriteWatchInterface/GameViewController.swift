//
//  GameViewController.swift
//  SpriteWatchInterface
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

import UIKit
import SpriteKit
import GameplayKit
import WatchConnectivity

class GameViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleBar: UINavigationItem!
    
    static let WIDTH_SCENE = 312
    static let HEIGHT_SCENE = 390
    
    var mainTableViewAdapter : MainTableViewAdapter?
    let faces = StyleOrganized.themes
    var data = [[Any]]()
    var selection = [Bool]()
    
    let ducumentPath = NSHomeDirectory() + "/Documents"
    var settingPlist : String?
    var settings : Dictionary<String, Any>?
    
    let fileManager = FileManager.default
    var session : WCSession?
    
    var isSending = false
    
    
    func initSettings()
    {
        //print(ducumentPath)
        settingPlist = ducumentPath + "/setting.plist"
        createFile()
        // Read file
        settings = NSDictionary(contentsOfFile: settingPlist!) as? Dictionary<String,Any>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSettings()
        
        
        titleBar.title = "设置"
        
        
        for itm in faces
        {
            data.append(itm)
            selection.append(false)
        }
        
        let selectedRowId = (settings!["interfaceID_current"] as! Dictionary<String, Int>)["id"]!
        for (index,item) in StyleOrganized.themes.enumerated()
        {
            if item[2] as! Int == selectedRowId
            {
                selection[index] = true
            }
        }
        
        mainTableViewAdapter = MainTableViewAdapter(controller : self, viewFrame : self.view.frame, data : data, selection : selection)
        
        mainTableView!.delegate = mainTableViewAdapter
        mainTableView!.dataSource = mainTableViewAdapter
        mainTableView!.register(MainTableCell.self, forCellReuseIdentifier: "item")
        mainTableViewAdapter?.setOnClickListener(onClick: { (index : Int) in
            var dict = self.settings!["interfaceID_current"] as! Dictionary<String, Int>
            dict["id"] = self.faces[index][2] as? Int
            dict["time"] = Int(Date().timeIntervalSince1970)
            self.settings!["interfaceID_current"] = dict
            self.saveFile()
            if (self.session!.isReachable)
            {
                self.sendMessage(session: self.session!, message: self.settings!, replyHandler: { (reply : [String : Any]) in
                    //self.showToast("设置成功")
                })
            } else
            {
                self.showToast("与手表通讯失败，已保存，下次成功时会主动设置")
            }
        })
        
        connect()
        
        
        /*if let view = self.view as! SKView? {
         
         let scene = FaceScene(size : CGSize(width: 312, height: 390))
         
         // Set the scale mode to scale to fit the window
         scene.scaleMode = .aspectFit
         scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
         
         // Present the scene
         view.presentScene(scene)
         view.ignoresSiblingOrder = true
         view.showsFPS = true
         view.showsNodeCount = true
         }*/
    }
    
    func updateUI()
    {
        print(#function)
        selection = selection.map { (origin : Bool) -> Bool in
            return false
        }
        let selectedRowId = (settings!["interfaceID_current"] as! Dictionary<String, Int>)["id"]!
        for (index,item) in StyleOrganized.themes.enumerated()
        {
            if item[2] as! Int == selectedRowId
            {
                selection[index] = true
            }
        }
        DispatchQueue.main.async {
            self.mainTableViewAdapter!.update(tableView: self.mainTableView, selection: self.selection)
        }
        
    }
    
    func connect()
    {
        
        if #available(iOS 9.0, *) {
            // Some properties can be checked only for iOS Device
            // WCSession.default.isPaired
            // WCSession.default.isWatchAppInstalled
            // WCSession.default.isComplicationEnabled
            if WCSession.isSupported() {
                session = WCSession.default
                session!.delegate = self
                session!.activate()
            } else {
                print("Unsupport")
                // Current iOS device dot not support session
            }
        } else {
            print("version down")
            // The version of system is not available
        }
    }
    
    func doSomethingWhenSessionActive()
    {
        sendMessage(session: session!, message: self.settings!, replyHandler: { (reply : [String : Any]) in
            self.exchangeData(reply)
            print("Succeed_first \(reply)")
        })
    }
    
    // Call when data received
    func exchangeData(_ message : [String : Any])
    {
        isSending = false
        ProgressHUD.dismiss()
        if let localDataCreateTime = (settings!["interfaceID_current"] as! Dictionary<String, Int>)["time"], let dataReceviedTime = (message["interfaceID_current"] as! Dictionary<String, Int>)["time"]
        {
            if localDataCreateTime < dataReceviedTime
            {
                settings = message
                print("changed!")
                saveFile()
                updateUI()
            }
        }
    }
    
    // Send
    public func sendMessage(session : WCSession, message : Dictionary<String,Any>, replyHandler : @escaping ([String : Any]) -> Void)
    {
        if (session.isReachable && !self.isSending)
        {
            self.isSending = true
            DispatchQueue.main.async {
                ProgressHUD.show()
            }
            //print("打开菊花")
            session.sendMessage(message, replyHandler: { (reply : [String : Any]) in
                self.isSending = false
                // 关闭菊花
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
                
                replyHandler(reply)
            }) { (e : Error) in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
                self.isSending = false
                self.showToast("与手表通讯失败，已保存，下次成功时会主动设置")
                print(e)
            }
        } else{
            if session.isPaired
            {
                if session.isWatchAppInstalled
                {
                    session.activate()
                    showToast("与手表的通讯出现了点小问题，设置可能不同步，请重试，还不行请尝试在手表上重开应用，以及在手机上重开！")
                } else
                {
                    showToast("手表应用未安装！")
                }
            } else
            {
                showToast("手表未匹配！")
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
     NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.awake), name: UIApplication.willEnterForegroundNotification, object: nil)
     }
     
     @objc func awake()
     {
     if scene != nil
     {
     (scene as! GameScene).fresh()
     print("i")
     }
     }
     
     override func viewWillDisappear(_ animated: Bool) {
     NotificationCenter.default.removeObserver(self)
     }*/
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
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
    
    /*override var prefersStatusBarHidden: Bool {
     return true
     }*/
    
    func showToast(_ str : String)
    {
        DispatchQueue.main.async {
            let dialog = UIAlertController(title: "Tip", message: str, preferredStyle: .alert)
            dialog.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    // -------- 实现 WCSessionDelegate ----------
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(#function)
        
        // isPaired == true 手表配对完毕
        // isWatchAppInstalled == true 代表手表应用被安装完毕
        // isComplicationEnabled 是否开启了复杂功能//就是那个表盘上面的那个四个显示区
        // 当 isReachable = true && activationState = .activated才能传输数据
        
        // printTest(session)
        
        if session.isPaired
        {
            if session.isWatchAppInstalled
            {
                doSomethingWhenSessionActive()
            } else
            {
                showToast("手表应用未安装！")
            }
        } else
        {
            showToast("手表未匹配！")
        }
        
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(#function)
        printTest(session)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print(#function)
        printTest(session)
    }
    
    // Receive
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler(settings!)
        exchangeData(message)
        //replyHandler(["reply":"I received your message"])
    }
    
    // Test Code
    func printTest(_ session : WCSession)
    {
        var message = ""
        switch (session.activationState)
        {
        case .activated:
            message += "activated"
        case .inactive:
            message += "inactive"
        case .notActivated:
            message += "notActivated"
        }
        message += " isPaired = \(session.isPaired)"
        message += " isComplicationEnabled = \(session.isComplicationEnabled)"
        message += " isWatchAppInstalled = \(session.isWatchAppInstalled)"
        message += " isReachable = \(session.isReachable)"
        
        showToast(message)
    }
    
    // ---------------------------------------------------------
    
    
    
    
    class MainTableViewAdapter : NSObject,UITableViewDelegate, UITableViewDataSource
    {
        var data : [[Any]]
        var viewFrame : CGRect
        var selection : [Bool]
        var onClick : ((Int) -> Void)?
        var controller : GameViewController
        
        init(controller : GameViewController, viewFrame : CGRect, data : [[Any]], selection : [Bool])
        {
            self.data = data
            self.viewFrame = viewFrame
            self.selection = selection
            self.controller = controller
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! MainTableCell
            cell.selectionStyle = .none
            
            let index = indexPath.row
            //判断一下
            if (selection[index])
            {
                cell.accessoryType = .checkmark
            } else
            {
                cell.accessoryType = .none
            }
            
            
            cell.title.text = (data[index][1] as! String)
            let scene = FaceScene(size: CGSize(width: WIDTH_SCENE, height: HEIGHT_SCENE), id: data[index][2] as! Int)
            scene.scaleMode = .aspectFit
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            cell.showingView.presentScene(scene)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return viewFrame.width / 2 + MainTableCell.topMargin * 2
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count // 返回每部分的长度
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if !controller.isSending
            {
                selection = selection.map { (origin : Bool) -> Bool in
                    return false
                }
                selection[indexPath.row] = true
                tableView.reloadData()
                if (onClick != nil)
                {
                    onClick!(indexPath.row)
                }
            }
        }
        
        func setOnClickListener(onClick : @escaping (Int) -> Void)
        {
            self.onClick = onClick
        }
        
        func update(tableView : UITableView, selection : [Bool])
        {
            self.selection = selection
            tableView.reloadData()
        }
        
        // 可以不写
        /*func numberOfSections(in tableView: UITableView) -> Int {
         return 1 // 返回部分数量 1，也就是种类数为 1
         }*/
    }
    
    class MainTableCell : UITableViewCell
    {
        var showingView : SKView
        var title : UILabel
        
        let leftMargin : CGFloat = 16
        static let topMargin : CGFloat = 10
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier:String?)
        {
            showingView = SKView()
            title = UILabel()
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            showingView.ignoresSiblingOrder = true
            showingView.showsFPS = true
            showingView.showsNodeCount = true
            //showingView.preferredFramesPerSecond = 1
            
        }
        
        //刚开始会报错，后来加了一段这个东西
        required init?(coder aDecoder: NSCoder)
        {
            fatalError("init(coder:) has not been implemented")
        }
        
        // init the views
        override func layoutSubviews() {
            super.layoutSubviews()
            let rect = bounds
            let WIDTH_VIEW = rect.width / 2 / CGFloat(HEIGHT_SCENE) * CGFloat(WIDTH_SCENE)
            
            showingView.frame = CGRect(x: leftMargin, y: MainTableCell.topMargin, width: WIDTH_VIEW, height: rect.width / 2)
            title.frame = CGRect(x: leftMargin + WIDTH_VIEW, y: 0, width: rect.width / 2 - leftMargin, height: rect.height)
            title.textAlignment = .center
            
            addSubview(showingView)
            addSubview(title)
        }
        
        /*override func awakeFromNib() //从布局文件醒来
         {
         super.awakeFromNib()
         // Initialization code
         }*/
        
        override func setSelected(_ selected: Bool, animated:Bool)
        {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
        }
        
        
        
    }
}

