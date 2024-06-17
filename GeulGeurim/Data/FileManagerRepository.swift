//
//  FileManagerRepository.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.06.2024.
//

import Foundation

public struct FileManagerRepository: FileRepositoryProtocol {
  public static let shared: FileManagerRepository = FileManagerRepository()
  
  private let fileManager = FileManager.default
  public static let baseDirectory: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)[0]
  
  private init() { }
  
  public func createDirectory(name: String, at path: String = "") throws {
    guard let path = path.removingPercentEncoding,
          let url = URL(string: path) else { throw FileManagerRepositoryError.urlEncodingFailed }
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
  
  public func saveFile(file: Data, at path: String) throws {
    guard let url = URL(string: path) else { throw FileManagerRepositoryError.urlEncodingFailed }

    if fileManager.fileExists(atPath: url.path) {
      throw FileManagerRepositoryError.fileAlreadyExists
    }
    
    do {
      try file.write(to: url)
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
  
  public func listFiles(at path: String) throws -> [FileInfo] {
    guard let path = path.removingPercentEncoding,
          let directoryURL = URL(string: path) else { throw FileManagerRepositoryError.urlEncodingFailed }
    do {
      let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey, .pathKey, .canonicalPathKey], options: .skipsHiddenFiles)
      
      return try fileURLs.map { url in
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey, .pathKey, .canonicalPathKey])

        var numberOfItems: Int? = nil
        if resourceValues.isDirectory ?? false {
          let subItems = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
          numberOfItems = subItems.count
        } 
        
        var fileData: Data?
        if let isDirectory = resourceValues.isDirectory,
          !isDirectory {
          fileData = try Data(contentsOf: url)
        }
        
        return FileInfo(
          name: url.lastPathComponent,
          isDirectory: resourceValues.isDirectory ?? false,
          fileSize: resourceValues.fileSize.map { Int64($0) },
          creationDate: resourceValues.creationDate,
          modificationDate: resourceValues.contentModificationDate,
          fileExtension: url.pathExtension,
          numberOfItems: numberOfItems,
          data: fileData,
          path: url.relativeString
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
  case urlEncodingFailed
  
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
    case .urlEncodingFailed:
      return "URL encoding failed for an unknown reason."
    }
  }
}
