//
//  AppCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class AppCoordinator: BaseCoordinator {
  public var window: UIWindow
  
  public init(window: UIWindow, navigationController: UINavigationController) {
    self.window = window
    super.init(navigationController: navigationController)
  }
  
  public override func start() {
    let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
    tabBarCoordinator.start()
    childCoordinators.append(tabBarCoordinator)
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
}
