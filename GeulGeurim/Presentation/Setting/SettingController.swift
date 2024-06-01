//
//  SettingController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class SettingController: UIViewController {
  private let mainView: SettingView = SettingView()
  private let tabBarItemType: TabBarItemType = .setting
  
  public override func loadView() {
    super.loadView()
    view = mainView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
}
