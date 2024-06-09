//
//  RxPressable.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.06.2024.
//

import UIKit

/// `RxPressable` 프로토콜은 `RxTouchable`을 준수하는 UIView 또는 그 서브 클래스에서 터치 이벤트에 따른 애니메이션 효과 구현 인터페이스를 제공해요.
///
/// __Method__
/// `press`는 사용자가 View를 터치했을 때 애니메이션 효과를 적용합니다
/// `unpress`는 사용자가 View에서 손을 뗐을 때 애니메이션 효과를 초기화합니다.
///
public protocol RxPressable: UIView {
  /// Method to transition to press state
  func press()
  
  /// Method to release from press state
  func unpress()
}
