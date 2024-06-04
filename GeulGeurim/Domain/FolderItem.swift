//
//  FolderItem.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import Foundation

public struct FolderItem: FileItemProtocol {
  public var name: String
  public let createdDate: Date
  public let subfilesCount: Int
  public let type: FileItemType = .folder
  
  init(fileName: String, createdDate: Date, subfilesCount: Int) {
    self.name = fileName
    self.createdDate = createdDate
    self.subfilesCount = subfilesCount
  }
}
