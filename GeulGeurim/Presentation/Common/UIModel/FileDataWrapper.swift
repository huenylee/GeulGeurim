//
//  FileDataWrapper.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 29.05.2024.
//

import Foundation

/// FileProtocol을 준수하는 객체를 Concrete type으로 관리하기 위한 래퍼 구조체
///
/// __Properties__
///
/// __file__: FileProtocol을 준수하는 객체
///
public struct FileDataWrapper: Hashable {
  private let _hash: (inout Hasher) -> Void
  private let _equals: (Any) -> Bool
  let file: any FileProtocol
  
  init<T: FileProtocol & Hashable>(_ file: T) {
    self.file = file
    self._hash = { hasher in
      file.hash(into: &hasher)
    }
    self._equals = { other in
      guard let otherItem = other as? T else { return false }
      return file == otherItem
    }
  }
  
  public func hash(into hasher: inout Hasher) {
    _hash(&hasher)
  }
  
  public static func == (lhs: FileDataWrapper, rhs: FileDataWrapper) -> Bool {
    lhs._equals(rhs.file)
  }
}
