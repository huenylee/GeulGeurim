//
//  TabBarController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 27.05.2024.
//

import UIKit

final class TabBarController: UITabBarController {
  private let tabBarControllers: [TabBarItemType: UINavigationController]
  
  init(tabBarControllers: [TabBarItemType : UINavigationController]) {
    self.tabBarControllers = tabBarControllers
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("해제됨: TabBarController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTabBarItem()
    setupTabBarAppearance()
  }
  
  /// 탭바 설정 메소드
  private func setupTabBarItem() {
    self.tabBar.tintColor = UIColor.primaryNormal
    
    let navigationControllers = TabBarItemType.allCases.map { item -> UINavigationController in
      guard let tab = tabBarControllers[item] else {
        fatalError()
      }
      
      if let defaultImage = item.tabIconImage {
        tab.tabBarItem.image = defaultImage
      }
      tab.tabBarItem.title = item.title
      return tab
    }
    
    viewControllers = navigationControllers
  }
  
  private func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()

    self.tabBar.standardAppearance = appearance
    self.tabBar.scrollEdgeAppearance = appearance
  }
}
