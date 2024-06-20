//
//  DeleteFileUseCase.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 19.06.2024.
//

import Foundation

public struct DeleteFileUseCase {
  private let repository: FileRepositoryProtocol
  
  func execute(at path: String) throws {
    try repository.deleteFile(at: path)
  }
  
  init(repository: FileRepositoryProtocol) {
    self.repository = repository
  }
}
