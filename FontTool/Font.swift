//
//  Font.swift
//  FontTool
//
//  Created by Lucas Assis Rodrigues on 15.11.18.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import Foundation

class Font {
    private lazy var map: [(name: String, value: String)] = {
        let css = cssMapping
        let characters = characterMapping

        return css.lazy
            .enumerated()
            .map { ($0.element, characters[$0.offset] ) }
            .sorted { $0.name < $1.name }
    }()

    private var path: String { return "\(currentPath)/icons-reference.html" }
    private lazy var file: String = {
        let errorMessage = "icons-reference.html needs to be on the folder with the command line tool."
        do {
            let file = try String(contentsOfFile: path)
            return file
        } catch {
            ANSIColors.yellow.set
            print(path)
            ANSIColors.red.set
            print(errorMessage)
            ANSIColors.original.set
            fatalError()
        }
    }()

    private lazy var tokens: [String] = { return file.components(separatedBy: "\n") }()
    private var cssMapping: [String] {
        guard let firstIndex = tokens.firstIndex(where: { $0.contains("CSS mapping") }) else { fatalError("HTML file with unexpected format.") }
        guard let lastIndex = tokens.firstIndex(where: { $0.contains("Character mapping") }) else { fatalError("HTML file with unexpected format.") }

        return parse(fromIndex: firstIndex, to: lastIndex) {
            $0.components(separatedBy: "-")
                .lazy
                .enumerated()
                .map { t -> String in t.offset == 0 ? t.element : "\(t.element.prefix(1).uppercased())\(t.element.dropFirst())" }
                .joined()
        }
    }

    private var characterMapping: [String] {
        guard let firstIndex = tokens.firstIndex(where: { $0.contains("Character mapping") }) else { fatalError("HTML file with unexpected format.") }
        guard let lastIndex = tokens.firstIndex(where: { $0 == tokens.last }) else { fatalError("HTML file with unexpected format.") }

        return parse(fromIndex: firstIndex, to: lastIndex) { s -> String in
            let result: String
            if s.hasPrefix("&amp;#") {
                result = "\\u{\(String(s.dropFirst(7)).dropLast())}"
            } else if s == "&gt;" || s == "&#62;" {
                return ">"
            } else if s == "&amp;" || s == "&#38;" {
                return "&"
            } else if s == "&quot;" || s == "&#34;" {
                return "\\\""
            } else if s == "&apos;" || s == "&#39;" {
                return "'"
            } else if s == "&lt;" || s == "&#60;" {
                return "<"
            } else {
                result = s
            }

            return result
        }
    }

    private func parse(fromIndex firstIndex: Int, to lastIndex: Int, withStringTransformation transformation: (String) -> String) -> [String] {
        let list = Array(
            tokens[firstIndex + 1 ..< lastIndex].lazy
                .filter { $0.contains("input") }
                .flatMap { $0.components(separatedBy: "\"") }
        )

        let trimCharSet = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "<=>\""))
        let result: [String] = list.lazy
            .map { $0.trimmingCharacters(in: trimCharSet) }
            .enumerated()
            .compactMap { $0.element == "value" ? list[$0.offset + 1] : nil }
            .map(transformation)

        return result
    }

    func toSwift(filePath: String) throws {
        var fileContent = """
                          import Foundation

                          /// List of all available fonts with its code.
                          enum FontCode: String {
                          """

        map.forEach {
            fileContent.append("\n\tcase \($0.name) = \"\($0.value)\"")
        }

        fileContent.append("\n}")
        try fileContent.write(toFile: filePath, atomically: false, encoding: .utf8)
    }
}
