//
//  LibraryCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class LibraryCoordinator: BaseCoordinator {
  public override func start() {
    let reactor = LibraryReactor(
      createFolderUseCase: CreateFolderUseCase(repository: FileManagerRepository.shared),
      fetchLibraryFilesUseCase: FetchLibraryFilesUseCase(repository: FileManagerRepository.shared), 
      downloadFileUseCase: DownloadFileUseCase(repository: FileManagerRepository.shared)
    )
    let libraryController = LibraryController(reactor: reactor, title: "보관함")
    navigationController.pushViewController(libraryController, animated: true)
  }
}
