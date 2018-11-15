//
//  main.swift
//  FontTool
//
//  Created by Lucas Assis Rodrigues on 15.11.18.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import Foundation

var currentPath: String {
    return CommandLine.arguments[0]
        .components(separatedBy: "/")
        .lazy
        .dropLast()
        .joined(separator: "/")
}

let font = Font()
let fontCodePath = currentPath + "/FontCode.swift"
FileManager.default.createFile(atPath: fontCodePath, contents: nil, attributes: nil)
try font.toSwift(filePath: fontCodePath)

ANSIColors.green.set
print("Great success!!! 👍")
ANSIColors.original.set
