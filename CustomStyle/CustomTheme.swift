//
//  CustomTheme.swift
//  SpriteWatchInterface
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

import Foundation

enum ThemeError : Error {
    case FileNotFound
    case DirectoryError
    case InformationFileError
    case ElementFileError
}

class CustomTheme
{
    
    var informationDict = [String : String]()
    
    var name : String
    {
        didSet
        {
            informationDict["name"] = name
        }
    }
    var time : String
    {
        didSet
        {
            informationDict["time"] = time
        }
    }
    private(set) var rootDir : File
    private(set) var themeDir : File
    
    // Something like "~/.../.../SpriteClock", not theme directory
    init(name : String, time : String, rootDir : File)
    {
        self.name = name
        self.time = time
        informationDict["name"] = name
        informationDict["time"] = time
        self.rootDir = rootDir
        self.themeDir = self.rootDir.append(childName: "tmp_\(time)_\(name)")
    }
    
    // Something like "~/.../.../SpriteClock", not theme directory
    init(name : String, time : String, rootDirPath : String)
    {
        self.name = name
        self.time = time
        informationDict["name"] = name
        informationDict["time"] = time
        self.rootDir = File(path: rootDirPath)
        self.themeDir = self.rootDir.append(childName: "tmp_\(time)_\(name)")
    }
    
    private init(name : String, time : String, themeDir : File) throws
    {
        self.name = name
        self.time = time
        informationDict["name"] = name
        informationDict["time"] = time
        self.themeDir = themeDir
        self.rootDir = self.themeDir.getParentFile()
        if self.themeDir.path.elementsEqual(self.rootDir.path)
        {
            throw ThemeError.DirectoryError
        }
    }
    
    // Something like "~/.../.../SpriteClock/1560606239456254_theme1", theme directory
    static func read(themeDirPath : String) throws -> CustomTheme
    {
        return try read(themeDir: File(path: themeDirPath))
    }
    
    static func read(themeDir : File) throws -> CustomTheme
    {
        if themeDir.isDirectory()
        {
            // Read information.plist
            if let theme = try readInformation(themeDir: themeDir)
            {
                // Read elements.plist
                // TODO: XXX
                
                
                return theme
            } else
            {
                throw ThemeError.InformationFileError
            }
        } else
        {
            throw ThemeError.FileNotFound
        }
    }
    
    private static func readInformation(themeDir : File) throws -> CustomTheme?
    {
        let information = themeDir.append(childName: "information.plist")
        if let nsDict = NSDictionary(contentsOfFile: information)
        {
            if let dict = nsDict as? Dictionary<String,String>, let name = dict["name"], let time = dict["time"]
            {
                return try CustomTheme(name: name, time: time, themeDir: themeDir)
            }
        }
        return nil
    }
    
    func write(isFirstTmp : Bool) throws
    {
        if isFirstTmp
        {
            // Try to create new temporary theme directory
            let _ = try themeDir.createDirectory(withIntermediateDirectories: true, attributes: nil)
            // Write information.plist
            try writeInformation()
        } else {
            try write()
        }
    }
    
    func write() throws {
        // Write information.plist
        try writeInformation()
        // Write elements.plist
        
        
    }
    
    // Write information.plist
    private func writeInformation() throws
    {
        try (informationDict as NSDictionary).write(to: themeDir.append(childName: "information.plist"))
    }
    
    func commit() throws
    {
        // Remove "tmp_" if it has
    }
    
    func delete() throws
    {
        try themeDir.delete()
    }
}
