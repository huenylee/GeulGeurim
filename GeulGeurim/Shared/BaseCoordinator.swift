//
//  BaseCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

open class BaseCoordinator: Coordinator {
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var navigationController: UINavigationController
  public var childCoordinators: [Coordinator] = []
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  deinit {
    print("Deinitialized \(Swift.type(of: self))")
  }
  
  open func start() {
    
  }
}

extension BaseCoordinator: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    self.removeChildCoordinator(childCoordinator)
  }
}
