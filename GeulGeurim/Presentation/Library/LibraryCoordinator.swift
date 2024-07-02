//
//  LibraryCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class LibraryCoordinator: BaseCoordinator {
  private let textFileViewerCoordinator: TextFileViewerCoordinator
  
  public init(
    textFileViewerCoordinator: TextFileViewerCoordinator,
    navigationController: UINavigationController
  ) {
    self.textFileViewerCoordinator = textFileViewerCoordinator
    super.init(navigationController: navigationController)
  }
  
  public func start() {
    let reactor = LibraryReactor(
      createFolderUseCase: CreateFolderUseCase(repository: FileManagerRepository.shared),
      fetchLibraryFilesUseCase: FetchLibraryFilesUseCase(repository: FileManagerRepository.shared), 
      downloadFileUseCase: DownloadFileUseCase(repository: FileManagerRepository.shared),
      deleteFileUseCase: DeleteFileUseCase(repository: FileManagerRepository.shared),
      renameFileUseCase: RenameFileUseCase(repository: FileManagerRepository.shared)
    )
    let libraryController = LibraryController(reactor: reactor, title: "보관함")
    libraryController.delegate = self
    navigationController.pushViewController(libraryController, animated: true)
  }
}

extension LibraryCoordinator: LibraryCoordinatorDelegate {
  public func presentToTextFileViewer(file: ContentFile) {
    textFileViewerCoordinator.start(file: file)
    childCoordinators.append(textFileViewerCoordinator)
  }
}
