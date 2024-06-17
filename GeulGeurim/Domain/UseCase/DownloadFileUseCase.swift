//
//  DownloadFileUseCase.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation

public struct DownloadFileUseCase {
  private let repository: FileRepositoryProtocol
  
  func execute(file: Data, fileName: String, at path: String) throws {
    let fullyPath: String = path + fileName
    print("저장할 경로: \(fullyPath)")
    try repository.saveFile(file: file, at: fullyPath)
  }
  
  init(repository: FileRepositoryProtocol) {
    self.repository = repository
  }
}
