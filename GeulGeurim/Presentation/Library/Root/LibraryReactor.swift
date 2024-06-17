//
//  LibraryReactor.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation
import ReactorKit

public final class LibraryReactor: Reactor {
  private let createFolderUseCase: CreateFolderUseCase
  private let fetchLibraryFilesUseCase: FetchLibraryFilesUseCase
  private let downloadFileUseCase: DownloadFileUseCase
  
  public enum Action {
    case createFolder(folderName: String)
    case fetchFiles
    case downloadFiles(urls: [URL])
    //    case removeFile(file: Data)
    //    case moveDirectory(directoryName: String)
  }
  
  public enum Mutation {
    case setFiles([any FileProtocol])
    case setError(LibraryError?)
  }
  
  public struct State {
    var directoryPath: String
    var files: [FileWrapper] = []
    var error: LibraryError?
    
    public init(directoryPath: String = FileManagerRepository.baseDirectory.absoluteString, files: [FileWrapper] = [], error: LibraryError? = nil) {
      self.directoryPath = directoryPath
      self.files = files
      self.error = error
    }
  }
  
  public let initialState: State
  
  public init(
    createFolderUseCase: CreateFolderUseCase,
    fetchLibraryFilesUseCase: FetchLibraryFilesUseCase,
    downloadFileUseCase: DownloadFileUseCase,
    initialState: State = .init()
  ) {
    self.createFolderUseCase = createFolderUseCase
    self.fetchLibraryFilesUseCase = fetchLibraryFilesUseCase
    self.downloadFileUseCase = downloadFileUseCase
    self.initialState = initialState
  }
  
  public func copyWith(state: State) -> LibraryReactor {
    return LibraryReactor(
      createFolderUseCase: createFolderUseCase,
      fetchLibraryFilesUseCase: fetchLibraryFilesUseCase,
      downloadFileUseCase: downloadFileUseCase,
      initialState: state
    )
  }
}

extension LibraryReactor {
  public enum LibraryError: Error {
    case downloadFileFailed
    case createFolderFailed
    case fetchFilesFailed
    case invalidFileExtension
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    let currentPath = currentState.directoryPath
    switch action {
    case .createFolder(let folderName):
      do {
        try createFolderUseCase.execute(name: folderName, at: currentPath)
        self.action.onNext(.fetchFiles)
        return .empty()
      } catch {
        return .just(.setError(LibraryError.createFolderFailed))
      }
    case .fetchFiles:
      do {
        let files = try fetchLibraryFilesUseCase.execute(at: currentPath)
        return .just(.setFiles(files))
      } catch {
        return .just(.setError(LibraryError.fetchFilesFailed))
      }
    case .downloadFiles(let urls):
      let downloadObservables = urls.map { url in
        Observable<Mutation>.create { [weak self] observer in
          do {
            let data = try Data(contentsOf: url)
            let fileType = data.checkFileType()
            if (fileType == .txt || fileType == .pdf),
               (url.pathExtension == "txt" || url.pathExtension == "pdf") {
              let fileName = url.lastPathComponent
              try self?.downloadFileUseCase.execute(file: data, fileName: fileName, at: currentPath)
              observer.onCompleted()
            } else {
              observer.onError(LibraryError.invalidFileExtension)
            }
          } catch {
            observer.onError(LibraryError.downloadFileFailed)
          }
          return Disposables.create()
        }
      }
      return Observable.concat(downloadObservables)
        .observe(on: MainScheduler.asyncInstance)
        .catch { error in
          return Observable.just(.setError(LibraryError.downloadFileFailed))
        }
        .concat(Observable.just(Mutation.setError(nil)))
        .concat(Observable.create { observer in
          self.action.onNext(.fetchFiles)
          observer.onCompleted()
          return Disposables.create()
        })
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setFiles(let files):
      newState.files = files.map { FileWrapper($0) }
    case .setError(let error):
      newState.error = error
      return newState
    }
    return newState
  }
}
