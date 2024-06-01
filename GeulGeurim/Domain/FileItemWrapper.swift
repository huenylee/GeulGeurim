//
//  FileItemWrapper.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 29.05.2024.
//

import Foundation

/// File(Folder, Conetnt)에 공통적인 요구사항을 정의한 FileItemProtocol이에요.
public protocol FileItemProtocol: Hashable {
  var name: String { get }
  var createdDate: Date { get }
  var type: FileItemType { get }
}

/// FileItem의 유형을 정의한 열거형이에요.
public enum FileItemType: Hashable {
  case content(ContentItemType)
  case folder
}

/// FileItemProtocol을 준수하는 객체를 Concrete type으로 관리하기 위한 래퍼 구조체
///
/// __Properties__
///
/// __file__: FileItemProtocol을 준수하는 객체
///
public struct FileItemWrapper: Hashable {
  private let _hash: (inout Hasher) -> Void
  private let _equals: (Any) -> Bool
  let file: any FileItemProtocol
  
  init<T: FileItemProtocol & Hashable>(_ file: T) {
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
  
  public static func == (lhs: FileItemWrapper, rhs: FileItemWrapper) -> Bool {
    lhs._equals(rhs.file)
  }
}
