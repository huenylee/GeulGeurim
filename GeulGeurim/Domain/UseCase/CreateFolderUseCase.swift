//
//  CreateFolderUseCase.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation

public struct CreateFolderUseCase {
  private let repository: FileRepositoryProtocol
  
  /// 특정 경로에 디렉토리를 생성해요.
  ///
  /// __Parameters__
  /// **name**: 디렉토리 이름
  /// **path**: 디렉토리 경로
  ///
  /// __Error throwable__
  /// **directoryAlreadyExists**
  /// **createDirectoryFailed**
  ///
  func execute(name: String, at path: String) throws {
    try repository.createDirectory(name: name, at: path)
  }
  
  init(repository: FileRepositoryProtocol) {
    self.repository = repository
  }
}
