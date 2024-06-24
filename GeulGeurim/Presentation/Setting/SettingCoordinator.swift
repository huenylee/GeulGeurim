//
//  SettingCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class SettingCoordinator: BaseCoordinator {
  public func start() {
    let settingController = SettingController()
    navigationController.pushViewController(settingController, animated: true)
  }
}
