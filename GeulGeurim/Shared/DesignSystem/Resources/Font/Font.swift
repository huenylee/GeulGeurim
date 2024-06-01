//
//  Font.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public enum Font {
  case Pretendard(Pretendard)
  
  public func of(size: CGFloat) -> UIFont {
    switch self {
    case .Pretendard(let pretendardWeight):
      return UIFont(name: pretendardWeight.fontFamilyName, size: size)!
    }
  }
  
  //MARK: - Body
  /// SemiBold_14
  static let B1_SemiBold: UIFont = Self.Pretendard(.SemiBold).of(size: 14)
  /// Regular_14
  static let B1_Regular: UIFont = Self.Pretendard(.Regular).of(size: 14)
  /// Medium_14
  static let B2_Medium: UIFont = Self.Pretendard(.Medium).of(size: 14)
  
  //MARK: - Headline
  /// Bold_26
  static let H1_Bold: UIFont = Self.Pretendard(.Bold).of(size: 26)
  /// SemiBold_24
  static let H2_SemiBold: UIFont = Self.Pretendard(.SemiBold).of(size: 24)
  
  //MARK: - Title
  /// Regular_18
  static let T1_Regular: UIFont = Self.Pretendard(.Regular).of(size: 18)
  /// SemiBold_18
  static let T2_SemiBold: UIFont = Self.Pretendard(.SemiBold).of(size: 18)
  /// SemiBold_16
  static let T3_SemiBold: UIFont = Self.Pretendard(.SemiBold).of(size: 16)
  /// Regular_16
  static let T4_Regular: UIFont = Self.Pretendard(.Regular).of(size: 16)
  
  // Caption
}

public enum Pretendard: String, CaseIterable {
  case Black
  case Bold, ExtraBold
  case Light, ExtraLight
  case Medium
  case Regular
  case SemiBold
  case Thin
  
  var fontFamilyName: String {
    return "Pretendard-\(self.rawValue)"
  }
}
