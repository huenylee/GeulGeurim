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
  let data: Data?
  let path: String
}

public extension FileInfo {
  func todomain() -> (any FileProtocol)? {
    guard let creationDate else { return nil }
    if isDirectory {
      guard let numberOfItems else { return nil }
      return FolderFile(name: name, createdDate: creationDate, subfilesCount: numberOfItems, path: path)
    } else {
      guard let type = ContentFileType(rawValue: fileExtension) else { return nil }
      guard let fileSize else { return nil }
      guard let data else { return nil }
      return ContentFile(name: name, createdDate: creationDate, fileSize: fileSize, type: .content(type), content: String(data: data, encoding: .utf8) ?? "", path: path)
    }
  }
}
