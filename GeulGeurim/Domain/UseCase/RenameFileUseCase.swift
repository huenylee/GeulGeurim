//
//  RenameFileUseCase.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 19.06.2024.
//

import Foundation

public struct RenameFileUseCase {
  private let repository: FileRepositoryProtocol
  
  func execute(name: String, at path: String) throws {
    try repository.renameFile(at: path, newName: name)
  }
  
  init(repository: FileRepositoryProtocol) {
    self.repository = repository
  }
}
