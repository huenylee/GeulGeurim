//
//  FileManagerRepository.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.06.2024.
//

import Foundation

public protocol FileRepositoryProtocol {
  func saveFile(data: Data, to fileName: String) throws
  func readFile(from fileName: String) throws -> Data
  func deleteFile(at fileName: String) throws
  func listFiles() throws -> [FileInfo]
}

public struct FileManagerRepository: FileRepositoryProtocol {
  public static let shared: FileManagerRepository = FileManagerRepository()
  
  private let fileManager = FileManager.default
  public static let baseDirectory: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)[0]
  
  private init() { }
  
  public func createDirectory(name: String, at url: URL = baseDirectory) throws {
    let newDirectory = url.appendingPathComponent(name)
    if fileManager.fileExists(atPath: newDirectory.path) {
      throw FileManagerRepositoryError.directoryAlreadyExists
    }
    do {
      try fileManager.createDirectory(at: newDirectory, withIntermediateDirectories: true, attributes: nil)
    } catch {
      throw FileManagerRepositoryError.createDirectoryFailed(error: error)
    }
  }
  
  public func saveFile(data: Data, to fileName: String) throws {
    let fileURL = FileManagerRepository.baseDirectory.appendingPathComponent(fileName)
    
    let filePath: String = {
      if #available(iOS 16.0, *) {
        return fileURL.path()
      } else {
        return fileURL.path
      }
    }()
    
    print(filePath)
    if fileManager.fileExists(atPath: filePath) {
      throw FileManagerRepositoryError.fileAlreadyExists
    }
    
    do {
      try data.write(to: fileURL)
    } catch {
      throw FileManagerRepositoryError.writeFailed(error: error)
    }
  }
  
  public func readFile(from fileName: String) throws -> Data {
    let fileURL = FileManagerRepository.baseDirectory.appendingPathComponent(fileName)
    do {
      return try Data(contentsOf: fileURL)
    } catch {
      throw FileManagerRepositoryError.readFailed(error: error)
    }
  }
  
  public func deleteFile(at fileName: String) throws {
    let fileURL = FileManagerRepository.baseDirectory.appendingPathComponent(fileName)
    do {
      try fileManager.removeItem(at: fileURL)
    } catch {
      throw FileManagerRepositoryError.deleteFailed(error: error)
    }
  }
  
  public func listFiles() throws -> [FileInfo] {
    do {
      let fileURLs = try fileManager.contentsOfDirectory(at: FileManagerRepository.baseDirectory, includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey], options: .skipsHiddenFiles)
      
      return try fileURLs.map { url in
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey])
        
        var numberOfItems: Int? = nil
        if resourceValues.isDirectory ?? false {
          let subItems = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
          numberOfItems = subItems.count
        }
        
        return FileInfo(
          name: url.lastPathComponent,
          isDirectory: resourceValues.isDirectory ?? false,
          fileSize: resourceValues.fileSize.map { Int64($0) },
          creationDate: resourceValues.creationDate,
          modificationDate: resourceValues.contentModificationDate,
          fileExtension: url.pathExtension,
          numberOfItems: numberOfItems
        )
      }
    } catch {
      throw FileManagerRepositoryError.listFilesFailed(error: error)
    }
  }
}

public enum FileManagerRepositoryError: Error {
  case directoryAlreadyExists
  case fileAlreadyExists
  case fileDoesNotExist(fileName: String)
  case createDirectoryFailed(error: Error)
  case writeFailed(error: Error)
  case readFailed(error: Error)
  case deleteFailed(error: Error)
  case listFilesFailed(error: Error)
  
  public var localizedDescription: String {
    switch self {
    case .directoryAlreadyExists:
      return "A directory with the same name already exists."
    case .fileAlreadyExists:
      return "A file with the same name already exists."
    case let .fileDoesNotExist(fileName):
      return "File not found: \(fileName)"
    case let .createDirectoryFailed(error):
      return "Failed to create directory: \(error.localizedDescription)"
    case let .writeFailed(error):
      return "Failed to write data to file: \(error.localizedDescription)"
    case let .readFailed(error):
      return "Failed to read data from file: \(error.localizedDescription)"
    case let .deleteFailed(error):
      return "Failed to delete file: \(error.localizedDescription)"
    case let .listFilesFailed(error):
      return "Failed to list files: \(error.localizedDescription)"
    }
  }
}
