//
//  LibraryController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit
import RxSwift
import ReactorKit

public final class LibraryController: BaseController, ReactorKit.View {
  private let mainView: LibraryView = LibraryView()
  private let tabBarItemType: TabBarItemType = .library
  private lazy var tableViewAdapter: LibraryTableViewAdapter = LibraryTableViewAdapter(tableView: mainView.tableView)

  public var disposeBag: DisposeBag = DisposeBag()
  
  public typealias Reactor = LibraryReactor
  required init(reactor: Reactor, title: String? = nil) {
    defer {
      self.reactor = reactor
      self.title = title
    }
    super.init()
  }
  
  public func bind(reactor: Reactor) {
    tableViewAdapter.delegate = self
    
    self.rx.viewIsAppear
      .map { _ in .fetchFiles }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.files)
      .distinctUntilChanged()
      .bind(with: self) { owner, files in
        owner.tableViewAdapter.applySnapshot(files: files)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.error)
      .bind(with: self) { owner, error in
        guard let error else { return }
        switch error {
        case .createFolderFailed:
          print("폴더 생성 실패")
        case .downloadFileFailed:
          print("파일 다운로드 실패")
        case .fetchFilesFailed:
          print("파일 불러오기 실패 ")
        case .invalidFileExtension:
          print("지원하지 않는 확장자")
        }
      }
      .disposed(by: disposeBag)
  
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    configureNavigationItem()
  }
  
  public override func configureUI() {
    super.configureUI()
    
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  private func configureNavigationItem() {
    navigationController?.navigationItem.largeTitleDisplayMode = .never
    navigationController?.navigationBar.tintColor = UIColor.basicBlack
    
    let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(add))
    add.tintColor = UIColor.basicBlack
    let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(search))
    search.tintColor = UIColor.basicBlack
    self.navigationItem.rightBarButtonItems = [
      add,
      search
    ]
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
  }
  
  @objc func search() {
    print(#function)
  }
  
  @objc func add() {
    let optionBottomSheetController = LibraryOptionsBottomSheetController()
    optionBottomSheetController.delegate = self
    present(optionBottomSheetController, animated: false)
  }
}

// MARK: - LibaryTableViewAdapterDelegate+Extension
extension LibraryController: LibraryTableViewAdapterDelegate {
  func libraryTableView(didUpdateItems itemCount: Int) {
    let hasData = itemCount > 0
    mainView.tableView.updateEmptyView(isHidden: hasData)
  }
  
  func libraryTableView(didSelectFolderItem file: any FileProtocol) {
    guard let reactor else { return }
    guard let path = file.path.removingPercentEncoding else { return }
    let newReactor = reactor.copyWith(state: .init(directoryPath: path))
    let libraryController = LibraryController(reactor: newReactor, title: file.name)
    navigationController?.pushViewController(libraryController, animated: true)
  }
  
  func libraryTableView(didSelectContentItem file: any FileProtocol) {
    guard let file = file as? ContentFile else { return }
    if let fileContent = String(data: file.data, encoding: .utf8) {
      print(fileContent)
    }
  }
  
  func libraryTableView(didLongPressOnItem file: any FileProtocol) {
    print("길게 누름")
    let actionMenuBottomSheetController = LibraryActionMenuBottomSheetController()
    actionMenuBottomSheetController.delegate = self
    present(actionMenuBottomSheetController, animated: false)
  }
}

// MARK: - LibraryOptionsBottomSheetDelegate+Extension
extension LibraryController: LibraryOptionsBottomSheetDelegate {
  public func presentToDocumentPickerController() {
    let documentController = UIDocumentPickerViewController(forOpeningContentTypes: [.text, .pdf], asCopy: true)
    documentController.allowsMultipleSelection = true
    documentController.delegate = self
    present(documentController, animated: true)
  }
  
  public func presentToCreateFolderController() {
    guard let reactor else { return }
    let createFolderModal = LibraryCreateFolderController(directoryPath: reactor.currentState.directoryPath)
    present(createFolderModal, animated: false)
    
    createFolderModal.dismissCallback = { [weak self] in
      self?.reactor?.action.onNext(.fetchFiles)
    }
  }
}

// MARK: - LibraryActionMenuBottomSheetDelegate+Extension
extension LibraryController: LibraryActionMenuBottomSheetDelegate {
  
}

// MARK: - UIDocumentPickerDelegate+Extension
extension LibraryController: UIDocumentPickerDelegate {
  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    reactor?.action.onNext(.downloadFiles(urls: urls))
  }
  
  public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print("사용자가 취소함")
  }
}
