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
  case more
  
  var title: String {
    switch self {
    case .readNow:
      return "지금 읽기"
    case .library:
      return "보관함"
    case .more:
      return "더보기"
    }
  }
  
  var tabIconImage: UIImage? {
    switch self {
    case .readNow:
      return UIImage(systemName: "book.fill")
    case .library:
      return UIImage(systemName: "books.vertical.fill")
    case .more:
      return UIImage(systemName: "ellipsis")
    }
  }
}
