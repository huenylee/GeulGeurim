//
//  ReadNowCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class ReadNowCoordinator: BaseCoordinator {
  public override func start() {
    let readNowController = ReadNowController()
    navigationController.pushViewController(readNowController, animated: true)
  }
}
