//
//  FolderFile.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import Foundation

public struct FolderFile: FileProtocol {
  public var name: String
  public let createdDate: Date
  public let subfilesCount: Int
  public let type: FileType = .folder
  public let path: String
  
  public init(name: String, createdDate: Date, subfilesCount: Int, path: String) {
    self.name = name
    self.createdDate = createdDate
    self.subfilesCount = subfilesCount
    self.path = path
  }
}
