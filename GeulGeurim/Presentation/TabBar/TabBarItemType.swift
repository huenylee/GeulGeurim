//
//  TabBarItemType.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 27.05.2024.
//

import UIKit

public enum TabBarItemType: CaseIterable {
  case readNow
  case library
  case setting
  
  var title: String {
    switch self {
    case .readNow:
      return "지금 읽기"
    case .library:
      return "보관함"
    case .setting:
      return "설정"
    }
  }
  
  var tabIconImage: UIImage? {
    switch self {
    case .readNow:
      return UIImage(systemName: "book.fill")
    case .library:
      return UIImage(systemName: "books.vertical.fill")
    case .setting:
      return UIImage(systemName: "gearshape.fill")
    }
  }
}
