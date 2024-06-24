//
//  TextFileViewerCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 20.06.2024.
//

import UIKit

public final class TextFileViewerCoordinator: BaseCoordinator {
  public func start(file: ContentFile) {
    let reactor = TextFileViewerReactor()
    let textFileViewerController = TextFileViewerController(reactor: reactor, file: file)
    textFileViewerController.modalPresentationStyle = .fullScreen
    navigationController.present(textFileViewerController, animated: true)
  }
}
