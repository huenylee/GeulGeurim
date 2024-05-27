//
//  LibraryCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class LibraryCoordinator: BaseCoordinator {
  public override func start() {
    let libraryController = LibraryController()
    navigationController.pushViewController(libraryController, animated: true)
  }
}
