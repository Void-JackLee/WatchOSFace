//
//  Wildcard.swift
//  SimpleWildcard
//
//  Created by 李弘辰 on 2019/6/18.
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

extension String
{
    /**
     Divide *String* instance with start and end index.
     
     - Parameters:
        - startIndex: The start index, Int, included. *[*startIndex,endIndex)
        - endIndex: The end index, Int, not included. *[*startIndex,endIndex)
     
     - Example:
     
        ```
        let str = "swift string"
        print(str.sub(startIndex: 0, endIndex: 3)) // It prints "swi".
        print(str.sub(startIndex: 6, endIndex: 12)) // It prints "string".
        ```
     
     - Returns: Returns string which you divided.
     */
    func sub(startIndex : Int, endIndex : Int) -> String
    {
        let start : String.Index = self.index(self.startIndex, offsetBy: startIndex)
        let end : String.Index = self.index(self.startIndex, offsetBy: endIndex)
        return String(self[start..<end])
    }
    
    /**
     Divide *String* instance with start and length you want.
     
     - Parameters:
        - startIndex: The start index, Int, included. *[*startIndex,startIndex + length)
        - length: The length of string you want to dive, Int. *[*startIndex,startIndex + length)
     
     - Example:
     
        ```
        let str = "swift string"
        print(str.sub(startIndex: 0, length: 3)) // It prints "swi".
        print(str.sub(startIndex: 6, length: 6)) // It prints "string".
        ```
     
     - Returns: Returns string which you divided.
     */
    func sub(startIndex : Int, length : Int) -> String
    {
        let start : String.Index = self.index(self.startIndex, offsetBy: startIndex)
        let end : String.Index = self.index(self.startIndex, offsetBy: startIndex + length)
        return String(self[start..<end])
    }
}
class Wildcard
{
    static var showLog = false
    /**
     Compare a *String* instance with wildcards to any string.
     
     - Parameters:
        - cmdStr: A *String* instance with wildcards or not.
        - name: Any *String* instance.
     
     - Example:
     
        ```
        print(Wildcard.contains(cmdStr: "*?*, *ard!", name: "Hello, Wildcard!")) // true
        print(Wildcard.contains(cmdStr: "*d!", name: "Hello, Wildcard!")) // true
        print(Wildcard.contains(cmdStr: "*?*????*?c??", name: "Hello, Wildcard!")) // false
        ```
     
     - Returns: Returns true if they are the same, false if they are not.
     */
    
    static func contains(cmdStr : String, name : String) -> Bool
    {
        /**
         Compare single character with wildcard(only ? or #).
         
         - Parameters:
            - cmdChar: A *Character* instance with wildcard(only ? or #) or not.
            - targetChar: Any *Character* instance.
         
         - Returns: Returns true if they are the same, false if they are not.
         */
        func isTheSame(cmdChar : Character, targetChar : Character) -> Bool
        {
            if cmdChar == targetChar || cmdChar == "?" || (cmdChar == "#" && (targetChar >= "0" && targetChar <= "9"))
            {
                return true
            }
            return false
        }
        
        /**
         Compare *String* instance with wildcards(only ? or #).
         
         - Parameters:
            - cmdStr: A *String* instance with wildcards(only ? or #) or not.
            - str: Any *String* instance.
         
         - Returns: Returns true if they are the same, false if they are not.
         */
        func compare(cmdStr : String, str : String) -> Bool
        {
            var isSame = false
            if cmdStr.count != str.count
            {
                if showLog { print("\"\(cmdStr)\" <with> \"\(str)\" Compared! -> \(isSame)") }
                return false
            }
            isSame = true
            for i in 0..<cmdStr.count
            {
                isSame = isTheSame(cmdChar: Character(cmdStr.sub(startIndex: i, length: 1)), targetChar: Character(str.sub(startIndex: i, length: 1)))
                if !isSame { break }
            }
            if showLog { print("\"\(cmdStr)\" <with> \"\(str)\" Compared! -> \(isSame)") }
            return isSame
        }
        
        if cmdStr.contains("*")
        {
            var str = name
            var fragments = cmdStr.components(separatedBy: "*")
            for i in (0..<fragments.count).reversed()
            {
                if fragments[i] == ""
                {
                    if (i != fragments.count - 1) && (i != 0)
                    {
                        fragments.remove(at: i)
                    }
                }
            }
            if showLog { print("-----------------------\nOrgin fragments = \(fragments)") }
            // fragments.count must >= 2
            
            let prefix = fragments[0]
            let suffix = fragments[fragments.count - 1]
            
            // Judge whether the suffix is the same
            if str.count >= suffix.count && compare(cmdStr: suffix, str: str.sub(startIndex: str.count - suffix.count, length: suffix.count))
            {
                // Cut
                str = String(str.prefix(str.count - fragments[fragments.count - 1].count))
                // Remove right
                fragments.remove(at: fragments.count - 1)
            } else
            {
                if showLog { print("Abort - Suffix wrong!") }
                return false
            }
            // Judge whether the prefix is the same
            if str.count >= prefix.count && compare(cmdStr: prefix, str: str.sub(startIndex: 0, length: prefix.count))
            {
                // Cut
                str = String(str.suffix(str.count - fragments[0].count))
                // Remove right
                fragments.remove(at: 0)
            } else
            {
                if showLog { print("Abort - Prefix wrong!") }
                return false
            }
            if showLog { print("Cut   fragments = \(fragments)")
                print("Cut   str = \(String.init(repeating: " ", count: prefix.count))\"\(str)\"\nOrgin str = \"\(name)\"") }
            let index = 0
            var startIndex = 0
            var endIndex = 0
            if index < fragments.count
            {
                endIndex = startIndex + fragments[index].count
                while endIndex <= str.count
                {
                    // Compare one by one
                    let cut = str.sub(startIndex: startIndex, endIndex: endIndex)
                    if compare(cmdStr: fragments[index], str: cut)
                    {
                        fragments.remove(at: index)
                        if fragments.count == 0 { break }
                        startIndex = endIndex - 1
                    }
                    startIndex += 1
                    endIndex = startIndex + fragments[index].count
                }
            }
            if fragments.count == 0
            {
                if showLog { print("\"\(name)\" Added!") }
                return true
            }
        } else
        {
            if compare(cmdStr: cmdStr, str: name)
            {
                if showLog { print("\"\(name)\" Added!") }
                return true
            }
        }
        return false
    }
    
    /**
     Compare a *String* instance with wildcards to any string.
     
     - Parameters:
        - cmdStr: A *String* instance with wildcards or not.
        - list: Any *[String]* instance.
     
     - Example:
     
        ```
        print(Wildcard.contains(cmdStr: "*.mp#", list: ["1.txt","2.mp3","hello.swift","hello.mp4"])) // ["2.mp3", "hello.mp4"]
        print(Wildcard.contains(cmdStr: "##_*??.*", list: ["01_class.txt","2_my.mp3","03_hello.swift","hello.mp4","05swift.java"])) //  ["01_class.txt", "03_hello.swift"]
        ```
     
     - Returns: Returns same *String* instance in a *[String]* list.
     */
    static func contains(cmdStr : String, list : [String]) -> [String]
    {
        var list_found = [String]()
        for str in list
        {
            if Wildcard.contains(cmdStr: cmdStr, name: str)
            {
                list_found.append(str)
            }
        }
        return list_found
    }
}

