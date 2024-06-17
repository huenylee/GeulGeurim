//
//  FetchLibraryFilesUseCase.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation

public struct FetchLibraryFilesUseCase {
  private let repository: FileRepositoryProtocol
  
  /// 앱 로컬 저장소의 파일 목록을 [FileProtocol] 형태로 가져와요.
  ///
  /// __Parameters__
  /// **option**
  ///
  /// __Error throwable__
  /// **listFilesFailed**
  ///
  func execute(option: SortOption = .byNameAscending, at path: String) throws -> [any FileProtocol] {
    let files = try repository.listFiles(at: path).compactMap { $0.todomain() }
    return sortFiles(files, by: option)
  }
  
  init(repository: FileRepositoryProtocol) {
    self.repository = repository
  }
  
  enum SortOption {
    /// 이름 가나다순
    case byNameAscending
    /// 날짜 최신순
    case byDateDescending
    /// 크기 큰 순
    case bySizeDescending
  }
  
  private func sortFiles(_ files: [any FileProtocol], by option: SortOption) -> [any FileProtocol] {
    switch option {
    case .byNameAscending:
      return files.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    case .byDateDescending:
      return files.sorted { $0.createdDate > $1.createdDate }
    case .bySizeDescending:
      // 파일과 폴더를 분류해요
      let (folders, contentFiles): ([FolderFile], [ContentFile]) = files.reduce(into: ([FolderFile](), [ContentFile]())) { result, file in
        switch file.type {
        case .folder:
          result.0.append(file as! FolderFile)
        case .content:
          result.1.append(file as! ContentFile)
        }
      }
      
      // 파일은 크기를 기준으로 내림차순으로 정렬해요
      let sortedContentFiles = contentFiles.sorted { file1, file2 in
        file1.fileSize > file2.fileSize
      }
      
      // 폴더는 하위 파일의 갯수에 따라 내림차순으로 정렬해요
      let sortedFolders = folders.sorted { folder1, folder2 in
        return folder1.subfilesCount > folder2.subfilesCount
      }
      
      // 정렬된 폴더와 파일을 합쳐 반환해요
      return sortedContentFiles + sortedFolders
    }
  }
}
