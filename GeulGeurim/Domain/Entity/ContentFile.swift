//
//  ContentFile.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 29.05.2024.
//

import Foundation

public struct ContentFile: FileProtocol {
  public var name: String
  public let createdDate: Date
  public let fileSize: Int64
  public let type: FileType
  public let content: String
  public let path: String
  
  public init(name: String, createdDate: Date, fileSize: Int64, type: FileType, content: String, path: String) {
    self.name = name
    self.createdDate = createdDate
    self.fileSize = fileSize
    self.type = type
    self.content = content
    self.path = path
  }
}
