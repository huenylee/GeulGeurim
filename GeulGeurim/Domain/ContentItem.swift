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
  public let fileSize: Int
  public let type: FileItemType = .content(.txt)
  
  init(fileName: String, createdDate: Date, fileSize: Int) {
    self.name = fileName
    self.createdDate = createdDate
    self.fileSize = fileSize
  }
}

public enum ContentItemType: Hashable {
  case txt
}
