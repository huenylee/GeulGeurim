//
//  EmptyViewRepresnetable.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 2.06.2024.
//

import UIKit

public protocol EmptyViewRepresnetable: UIView {
  var emptyView: UIView { get }
  func updateEmptyView(isHidden: Bool)
}

public extension EmptyViewRepresnetable {
  func updateEmptyView(isHidden: Bool) {
    if isHidden {
      emptyView.removeFromSuperview()
    } else {
      guard emptyView.superview == nil else { return }
      
      addSubview(emptyView)
      emptyView.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(238)
        $0.height.equalTo(106)
      }
    }
  }
}
