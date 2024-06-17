//
//  FileRepositoryProtocol.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation

public protocol FileRepositoryProtocol {
  func createDirectory(name: String, at path: String) throws
  func saveFile(file: Data, at fileName: String) throws
  func readFile(from fileName: String) throws -> Data
  func deleteFile(at fileName: String) throws
  func listFiles(at path: String) throws -> [FileInfo]
}
