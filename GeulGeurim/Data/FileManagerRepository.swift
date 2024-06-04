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
  private let baseDirectory: URL
  
  private init() {
    let urls = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
    self.baseDirectory = urls[0].appendingPathComponent("GeulGeurim")
    
    createDirectoryIfNeeded()
  }
  
  private func createDirectoryIfNeeded() {
    if !fileManager.fileExists(atPath: baseDirectory.path) {
      do {
        try fileManager.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)
      } catch {
        print("Failed to create directory: \(error)")
      }
    }
  }
  
  public func saveFile(data: Data, to fileName: String) throws {
    let fileURL = baseDirectory.appendingPathComponent(fileName)
    do {
      try data.write(to: fileURL)
      print(fileURL)
    } catch {
      throw error
    }
  }
  
  public func readFile(from fileName: String) throws -> Data {
    let fileURL = baseDirectory.appendingPathComponent(fileName)
    do {
      return try Data(contentsOf: fileURL)
    } catch {
      throw error
    }
  }
  
  public func deleteFile(at fileName: String) throws {
    let fileURL = baseDirectory.appendingPathComponent(fileName)
    do {
      try fileManager.removeItem(at: fileURL)
    } catch {
      throw error
    }
  }
  
  public func listFiles() throws -> [FileInfo] {
    do {
      let fileURLs = try fileManager.contentsOfDirectory(at: baseDirectory, includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey], options: .skipsHiddenFiles)
      
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
      throw error
    }
  }
}
