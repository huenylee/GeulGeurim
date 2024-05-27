//
//  TabBarCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {
  private var tabBarController: TabBarController?
  
  override func start() {
    let readNowCoordinator = ReadNowCoordinator(navigationController: UINavigationController())
    readNowCoordinator.start()
    readNowCoordinator.finishDelegate = self
    
    let libraryCoordinator = LibraryCoordinator(navigationController: UINavigationController())
    libraryCoordinator.start()
    libraryCoordinator.finishDelegate = self
    
    let moreCoordinator = MoreCoordinator(navigationController: UINavigationController())
    moreCoordinator.start()
    moreCoordinator.finishDelegate = self
    
    childCoordinators.append(readNowCoordinator)
    childCoordinators.append(libraryCoordinator)
    childCoordinators.append(moreCoordinator)
    
    let tabBarController = TabBarController(tabBarControllers: [
      .readNow: readNowCoordinator.navigationController,
      .library: libraryCoordinator.navigationController,
      .more: moreCoordinator.navigationController
    ])
    
    navigationController.setViewControllers([tabBarController], animated: false)
    self.tabBarController = tabBarController
  }
}
