//
//  LibraryReactor.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import Foundation
import ReactorKit

public struct FileListState: Hashable {
  let files: [FileDataWrapper]
  let animated: Bool
  
  public init(files: [FileDataWrapper], animated: Bool) {
    self.files = files
    self.animated = animated
  }
}

public final class LibraryReactor: Reactor {
  private let createFolderUseCase: CreateFolderUseCase
  private let fetchLibraryFilesUseCase: FetchLibraryFilesUseCase
  private let downloadFileUseCase: DownloadFileUseCase
  private let deleteFileUseCase: DeleteFileUseCase
  private let renameFileUseCase: RenameFileUseCase
  
  public enum Action {
    case createFolder(folderName: String)
    case fetchFiles(animated: Bool)
    case downloadFiles(urls: [URL])
    case renameFile(at: String, newName: String)
    case deleteFile(at: String)
    //    case removeFile(file: Data)
    //    case moveDirectory(directoryName: String)
  }
  
  public enum Mutation {
    case setFiles(FileListState)
    case setError(LibraryError?)
  }
  
  public struct State {
    var directoryPath: String
    var files: FileListState
    var error: LibraryError?
    
    public init(directoryPath: String = FileManagerRepository.baseDirectory.absoluteString, files: FileListState = .init(files: [], animated: false), error: LibraryError? = nil) {
      self.directoryPath = directoryPath
      self.files = files
      self.error = error
    }
  }
  
  public let initialState: State
  private var disposeBag: DisposeBag = DisposeBag()
  
  public init(
    createFolderUseCase: CreateFolderUseCase,
    fetchLibraryFilesUseCase: FetchLibraryFilesUseCase,
    downloadFileUseCase: DownloadFileUseCase,
    deleteFileUseCase: DeleteFileUseCase,
    renameFileUseCase: RenameFileUseCase,
    initialState: State = .init()
    ) {
    self.createFolderUseCase = createFolderUseCase
    self.fetchLibraryFilesUseCase = fetchLibraryFilesUseCase
    self.downloadFileUseCase = downloadFileUseCase
      self.deleteFileUseCase = deleteFileUseCase
      self.renameFileUseCase = renameFileUseCase
    self.initialState = initialState
    }
  
  public func copyWith(state: State) -> LibraryReactor {
    return LibraryReactor(
      createFolderUseCase: createFolderUseCase,
      fetchLibraryFilesUseCase: fetchLibraryFilesUseCase,
      downloadFileUseCase: downloadFileUseCase,
      deleteFileUseCase: deleteFileUseCase,
      renameFileUseCase: renameFileUseCase,
      initialState: state
    )
  }
}

extension LibraryReactor {
  public enum LibraryError: Error {
    case downloadFileFailed
    case createFolderFailed
    case renameFileFailed
    case fetchFilesFailed
    case invalidFileExtension
    case deleteFileFailed
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    let currentPath = currentState.directoryPath
    switch action {
    case .createFolder(let folderName):
      do {
        try createFolderUseCase.execute(name: folderName, at: currentPath)
        return Observable.just(Action.fetchFiles(animated: true))
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] action in
                self?.action.onNext(action)
            })
            .flatMap { _ in Observable<Mutation>.empty() }
      } catch {
        return .just(.setError(LibraryError.createFolderFailed))
      }
    case .fetchFiles(let animated):
      do {
        let files = try fetchLibraryFilesUseCase.execute(at: currentPath).map { FileDataWrapper($0) }
        let fileListState = FileListState(files: files, animated: animated)
        return .just(.setFiles(fileListState))
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
          self.action.onNext(.fetchFiles(animated: true))
          observer.onCompleted()
          return Disposables.create()
        })
    case .renameFile(let at, let newName):
      do {
        try renameFileUseCase.execute(name: newName, at: at)
        return Observable.just(Action.fetchFiles(animated: true))
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] action in
                self?.action.onNext(action)
            })
            .flatMap { _ in Observable<Mutation>.empty() }
      } catch {
        return .just(.setError(.renameFileFailed))
      }
    case .deleteFile(let at):
      do {
        try deleteFileUseCase.execute(at: at)
        return Observable.just(Action.fetchFiles(animated: true))
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] action in
                self?.action.onNext(action)
            })
            .flatMap { _ in Observable<Mutation>.empty() }
      } catch {
        return .just(.setError(.deleteFileFailed))
      }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setFiles(let fileListState):
      newState.files = fileListState
    case .setError(let error):
      newState.error = error
      return newState
    }
    return newState
  }
}
