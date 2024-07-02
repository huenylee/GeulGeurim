//
//  ContentFile+Extension.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.07.2024.
//

import Foundation

extension ContentFile {
  var formattedContent: String {
    let mtext = content.replacingOccurrences(of: "\n\n", with: "\n\n ")
    let pattern = "(?<!\n)\n(?!\n)"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: content.utf16.count)
    let modifiedText = regex.stringByReplacingMatches(in: mtext, options: [], range: range, withTemplate: "\n\n")
    
    return modifiedText
  }
}
