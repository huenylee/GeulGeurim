//
//  BaseCoordinator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public protocol CoordinatorFinishDelegate: AnyObject {
  func coordinatorDidFinish(childCoordinator: CoordinatorProtocol)
}

public protocol CoordinatorProtocol: AnyObject {
  var finishDelegate: CoordinatorFinishDelegate? { get set }
  var navigationController: UINavigationController { get set }
  var childCoordinators: [BaseCoordinator] { get set }
  
  func finish()
}

public extension CoordinatorProtocol {
  func finish() {
    childCoordinators.removeAll()
    finishDelegate?.coordinatorDidFinish(childCoordinator: self)
  }
  
  func removeChildCoordinator(_ childCoordinator: CoordinatorProtocol) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === childCoordinator {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}

open class BaseCoordinator: CoordinatorProtocol {
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var navigationController: UINavigationController
  public var childCoordinators: [BaseCoordinator] = []
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  deinit {
    print("Deinitialized \(Swift.type(of: self))")
  }
}

extension BaseCoordinator: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
    self.removeChildCoordinator(childCoordinator)
  }
}
