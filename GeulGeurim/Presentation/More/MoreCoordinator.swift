//
//  MoreCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class MoreCoordinator: BaseCoordinator {
  public override func start() {
    let moreController = MoreController()
    navigationController.pushViewController(moreController, animated: true)
  }
}
