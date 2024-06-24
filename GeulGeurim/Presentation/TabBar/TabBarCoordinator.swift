//
//  TabBarCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {
  private var tabBarController: TabBarController?
  
  public func start() {
    let readNowCoordinator = ReadNowCoordinator(navigationController: UINavigationController())
    readNowCoordinator.start()
    
    let libraryCoordinatorNavigationController = UINavigationController()
    let libraryCoordinator = LibraryCoordinator(textFileViewerCoordinator: TextFileViewerCoordinator(navigationController: libraryCoordinatorNavigationController), navigationController: libraryCoordinatorNavigationController)
    libraryCoordinator.start()
    
    let settingCoordinator = SettingCoordinator(navigationController: UINavigationController())
    settingCoordinator.start()
    
    childCoordinators.append(readNowCoordinator)
    childCoordinators.append(libraryCoordinator)
    childCoordinators.append(settingCoordinator)
    
    let tabBarController = TabBarController(tabBarControllers: [
      .readNow: readNowCoordinator.navigationController,
      .library: libraryCoordinator.navigationController,
      .setting: settingCoordinator.navigationController
    ])
    
    navigationController.navigationBar.isHidden = true
    navigationController.setViewControllers([tabBarController], animated: false)
    self.tabBarController = tabBarController
  }
}
