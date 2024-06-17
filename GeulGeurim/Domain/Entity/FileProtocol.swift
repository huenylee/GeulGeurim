//
//  FileProtocol.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation

/// File(Folder, Conetnt)에 공통적인 요구사항을 정의한 FileProtocol이에요.
public protocol FileProtocol: Hashable {
  var name: String { get }
  var createdDate: Date { get }
  var type: FileType { get }
  var path: String { get }
}

/// File의 유형을 정의한 열거형이에요.
public enum FileType: Hashable {
  case content(ContentFileType)
  case folder
}

/// ContentFile의 유형을 정의한 열거형이에요.
///
/// __txt__ 텍스트 파일
/// __pdf__ PDF 파일
public enum ContentFileType: String, Hashable {
  case txt
  case pdf
}
