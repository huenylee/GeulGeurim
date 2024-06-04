//
//  ContentItem.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 29.05.2024.
//

import Foundation

public struct ContentItem: FileItemProtocol {
  public let id: UUID = UUID()
  public var name: String
  public let createdDate: Date
  public let fileSize: Int64
  public let type: FileItemType
  
  init(fileName: String, createdDate: Date, fileSize: Int64, type: FileItemType) {
    self.name = fileName
    self.createdDate = createdDate
    self.fileSize = fileSize
    self.type = type
  }
}

public enum ContentItemType: String, Hashable {
  case txt
  case pdf
}
