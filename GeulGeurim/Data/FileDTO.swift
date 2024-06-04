//
//  FileInfo.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.06.2024.
//

import Foundation

public struct FileInfo {
  let name: String
  let isDirectory: Bool
  let fileSize: Int64?
  let creationDate: Date?
  let modificationDate: Date?
  let fileExtension: String
  let numberOfItems: Int?
}

public extension FileInfo {
  func todomain() -> (any FileItemProtocol)? {
    guard let creationDate else { return nil }
    if isDirectory {
      guard let numberOfItems else { return nil }
      return FolderItem(fileName: name, createdDate: creationDate, subfilesCount: numberOfItems)
    } else {
      guard let type = ContentItemType(rawValue: fileExtension) else { return nil }
      guard let fileSize else { return nil }
      return ContentItem(fileName: name, createdDate: creationDate, fileSize: fileSize, type: .content(type))
    }
  }
}
