//
//  AppDelegate.swift
//  WatchFace
//
//  Created by 李弘辰 on 2019/2/23.
//  Copyright © 2019 李弘辰. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (flag) {
            return false;
        } else{
            
            /*let windowController = (NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("controller")) as! WindowController) // 得在storyboard中设置id的
            windowController.window?.makeKeyAndOrderFront(self)*/
            NSApplication.shared.windows[0].makeKeyAndOrderFront(self)
            return true;
        }
    }
}


