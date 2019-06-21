//
//  File.swift
//  FileDemo by 李弘辰
//
//  Created by 李弘辰 on 2019/6/17.
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

enum FileError : Error {
    case FileNotFound
    case FileAlreadyExists
    case TargetDirectoryNotFound
}

class File
{
    private let manager = FileManager.default
    private(set) var path : String
    private(set) var url : URL
    
    /**
     Initical the *File* instance with path.
     
     - Parameters:
        - path: A file's absolute path.
     */
    init(path : String) {
        self.path = File.formatPath(path)
        self.url = URL(fileURLWithPath: self.path)
    }
    
    /**
     Initical the *File* instance with url.
     
     - Parameters:
        - url: A file's absolute url.
     */
    convenience init(url : URL) {
        self.init(path : url.path)
    }
    
    /**
     Judge a file or directory if it exsits.
     
     - Returns: Returns *true* if a file at the specified path exists, or *false* if the file does not exist or its existence could not be determined.
     */
    func isExsits() -> Bool
    {
        return manager.fileExists(atPath: path)
    }
    
    /**
     Judge a file if it is a directory.
     
     - Returns: Returns *true* if a file at the specified path exists and it is a directory, or *false* if the file does not exist or its existence could not be determined or it is not a directory.
     */
    func isDirectory() -> Bool {
        var directoryExists = ObjCBool.init(false)
        let fileExists = manager.fileExists(atPath: path, isDirectory: &directoryExists)
        return fileExists && directoryExists.boolValue
    }
    
    /**
     Append extra path to origin file path.
     
     - Parameters:
        - childName: File or directory name under its parent directory.
     
     - Returns: Appended path with *File* instance.
     */
    func append(childName : String) -> File {
        return File(path: "\(path)/\(childName)")
    }
    
    /**
     Get parent directory path of a file or directory.
     
     - Returns: Parent directory path.
     */
    func getParentPath() -> String {
        var separatedStr = File.separate(path)
        for i in (0 ..< separatedStr.count).reversed()
        {
            if separatedStr[i] == "/"
            {
                if i != 0
                {
                    separatedStr.remove(at: i)
                }
                break
            }
            separatedStr.remove(at: i)
        }
        return String(separatedStr)
    }
    
    /**
     Get parent directory path with a *File* instance of a file or directory.
     
     - Returns: Parent directory *File* instance.
     */
    func getParentFile() -> File{
        return File(path: getParentPath())
    }
    
    /**
     Get parent directory name of a file or directory.
     
     - Returns: Parent directory name.
     */
    func getParentName() -> String {
        var separatedStr = File.separate(path)
        var isRemoved : Int8 = 0
        for i in (0 ..< separatedStr.count).reversed()
        {
            if separatedStr[i] == "/"
            {
                if isRemoved == 0
                {
                    if i != 0
                    {
                        separatedStr.remove(at: i)
                    }
                    isRemoved = 1
                }else if isRemoved == 1
                {
                    isRemoved = 2
                }
            }
            if isRemoved == 0 || isRemoved == 2
            {
                separatedStr.remove(at: i)
            }
        }
        return String(separatedStr)
    }
    
    /**
     Get name of current file or directory.
     
     - Returns: Name of current file or directory.
     */
    func getName() -> String
    {
        if path == "/"
        {
            return "/"
        }
        var names = [Character]()
        for c in path.reversed()
        {
            if c == "/"
            {
                break
            }
            names.insert(c, at: 0)
        }
        return String(names)
    }
    
    /**
     Append extra path to origin file path.
     
     - Parameters:
        - withIntermediateDirectories: If true, this method creates any nonexistent parent directories as part of creating the directory in path. If false, this method fails if any of the intermediate parent directories does not exist. This method also fails if any of the intermediate path elements corresponds to a file and not a directory.
        - attributes: The file attributes for the new directory and any newly created intermediate directories. You can set the owner and group numbers, file permissions, and modification date. If you specify nil for this parameter or omit a particular value, one or more default values are used as described in the discussion. For a list of keys you can include in this dictionary, see Supporting Types. Some of the keys, such as hfsCreatorCode and hfsTypeCode, do not apply to directories.
     
     - Returns: Returns *true* if the directory was created, *true* if createIntermediates is set and the directory already exists, or *false* if an error occurred.
     */
    func createDirectory(withIntermediateDirectories : Bool, attributes: [FileAttributeKey : Any]?) throws -> Bool
    {
        if isExsits()
        {
            return false
        }
        try manager.createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
        if isExsits()
        {
            return true
        }
        return false
    }
    
    /**
     List the contents of a directory or a file's parent directory's contents.
     
     - Returns: Contents of a *File(Directory)* instance.
     */
    func list() throws -> [String]
    {
        if isDirectory()
        {
            return try manager.contentsOfDirectory(atPath: path)
        }else
        {
            let parentDir = getParentFile()
            if parentDir.isDirectory()
            {
                return try manager.contentsOfDirectory(atPath: parentDir.path)
            } else
            {
                throw NSError(domain: "Parent directory no found!", code: NSNotFound, userInfo: nil)
            }
        }
    }
    
    /**
     Delete self(if it was a directory)'s child file with name.
     
     - Parameters:
        - childName: File or directory name under its parent directory.
        - hasWildcard: File name with wildcard(*, ? or #) or not.
     
     - Returns: Returns *true* if a file at the specified path exists and it is a directory, or *false* if the file does not exist or its existence could not be determined or it is not a directory.
     */
    func delete(childName : String, hasWildcard : Bool) throws -> Bool
    {
        if isDirectory()
        {
            if hasWildcard
            {
                let fileList = try list()
                let deleteList = Wildcard.contains(cmdStr: childName, list: fileList)
                for item in deleteList
                {
                    try append(childName: item).delete()
                }
            } else {
                try append(childName: childName).delete()
            }
            return true
        } else
        {
            return false
        }
    }
    
    /**
     Delete file self.
     */
    func delete() throws {
        try manager.removeItem(atPath: path)
    }
    
    /**
     Move a file to another path, it will change *File* instance's path and url.
     
     - Parameters:
        - path: The new location for the item in *File* itself. It can be a exist directory or a nonexistent target file with a exist parent directory.
     */
    func move(to path : String) throws
    {
        try move(File(path: path))
    }
    
    /**
     Move a file to another path, it will change *File* instance's path and url.
     
     - Parameters:
        - url: The new location for the item in *File* itself. It can be a exist directory or a nonexistent target file with a exist parent directory.
     */
    func move(to url : URL) throws
    {
        try move(File(url: url))
    }
    
    /**
     Move a file to another path, it will change *File* instance's path and url.
     
     - Parameters:
        - dir: The new location for the item in *File* itself. It should be a exist directory.
     */
    func move(toDir dir : File) throws
    {
        try move(dir)
    }
    
    private func move(_ file : File) throws
    {
        func move(file : File) throws {
            try manager.moveItem(at: url, to: file.url)
            self.path = file.path
            self.url = file.url
        }
        
        if !isExsits()
        {
            throw FileError.FileNotFound
        } else if !file.isDirectory()
        {
            if file.isExsits() { throw FileError.FileAlreadyExists }
            else if !file.getParentFile().isDirectory()
            {
                throw FileError.TargetDirectoryNotFound
            } else {
                try move(file: file)
            }
        } else if file.path.elementsEqual(path) { throw FileError.FileAlreadyExists}
        else
        {
            let target = file.append(childName: getName())
            if target.isExsits() { throw FileError.FileAlreadyExists }
            else { try move(file: target) }
        }
    }
    
    /**
     Rename *File* instance itself.
     
     - Parameters:
        - name: New name.
     */
    func rename(to name : String) throws
    {
        try move(getParentFile().append(childName: name))
    }
    
    /**
     Format any Unix path to a proper way flexibly.
     
     - Parameters:
        - str : Any Unix path.
     
     - Returns: Formated path.
     */
    static func formatPath(_ str : String) -> String
    {
        var p = str
        // Get home directory
        if str.starts(with: "~")
        {
            p = NSHomeDirectory() + String(str.suffix(str.count - 1))
        }
        if p.starts(with: "/")
        {
            p = String(p.suffix(p.count - 1))
        } else
        {
            p = FileManager.default.currentDirectoryPath + "/" + str
        }
        // Remove repetition
        var separatedStr = File.separate(p)
        var isStart = true
        var isSeparater = false
        for i in (0 ..< separatedStr.count).reversed()
        {
            if separatedStr[i] == "/"
            {
                if isStart
                {
                    separatedStr.remove(at: i)
                } else {
                    if !isSeparater
                    {
                        isSeparater = true
                    } else {
                        separatedStr.remove(at: i)
                    }
                }
            } else
            {
                isStart = false
                isSeparater = false
            }
        }
        p = String(separatedStr)
        if !p.starts(with: "/")
        {
            p = "/" + p
        }
        p = simplifyPath(path: p)
        return p
    }
    
    /**
     Simplify relative path to absolute path.
     
     - Parameters:
        - path: Any Unix path.
     
     - Returns: Absolute path.
     */
    private static func simplifyPath(path : String) -> String
    {
        let u = URL(fileURLWithPath: path)
        var dirs = u.pathComponents
        var i = 0
        var count = dirs.count
        while i < count
        {
            if dirs[i].elementsEqual(".") || dirs[i].elementsEqual("..")
            {
                if dirs[i].elementsEqual("..") && i >= 2
                {
                    dirs.remove(at: i - 1)
                    i -= 1
                    count -= 1
                }
                dirs.remove(at: i)
                count -= 1
            } else { i += 1 }
        }
        dirs.remove(at: 0)
        var p = ""
        for d in dirs
        {
            p.append("/\(d)")
        }
        return p
    }
    
    
    /**
     Separate *String* instance into *[Character]*.
     
     - Parameters:
        - str: Any *String* instance.
     
     - Returns: Separated *String* instance with *[Character]*.
     */
    private static func separate(_ str : String) -> [Character]
    {
        var separatedStr = [Character]()
        for c in str
        {
            separatedStr.append(c)
        }
        return separatedStr
    }
}

extension NSDictionary
{
    /**
     Read a plist file to a NSDictionary.
     
     - Parameters:
        - file: The *File* which to raed to a dictionary.
     */
    convenience init?(contentsOfFile file : File) {
        self.init(contentsOf: file.url)
    }
    
    /**
     Write NSDictionary to the plist file.
     
     - Parameters:
        - file: The *File* which to write the dictionary.
     */
    func write(to file : File) throws
    {
        try self.write(to: file.url)
    }
}
