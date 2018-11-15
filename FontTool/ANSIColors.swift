//
//  ANSIColors.swift
//  FontTool
//
//  Created by Lucas Assis Rodrigues on 15.11.18.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import Foundation

enum ANSIColors: String, CaseIterable {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case original = "\u{001B}[0;0m"

    var set: Void {
        print(self.rawValue)
    }

    static func + (lhs: ANSIColors, rhs: String) -> String {
        return lhs.rawValue + rhs
    }

    static func + (lhs: String, rhs: ANSIColors) -> String {
        return lhs + rhs.rawValue
    }
}
