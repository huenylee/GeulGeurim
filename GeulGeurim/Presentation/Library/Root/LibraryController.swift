//
//  LibraryController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class LibraryController: BaseController {
  private let mainView: LibraryView = LibraryView()
  private let tabBarItemType: TabBarItemType = .library
  private lazy var tableViewAdapter: LibraryTableViewAdapter = LibraryTableViewAdapter(tableView: mainView.tableView)
  
  public override func loadView() {
    super.loadView()
    view = mainView
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    configureNavigationItem()
    fetch()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewAdapter.delegate = self
  }
  
  private func fetch() {
    let fileRepository = FileManagerRepository.shared
    do {
      let files = try fileRepository.listFiles()
      let entities = files.compactMap { $0.todomain() }
      let data = entities.map { FileItemWrapper($0) }
      tableViewAdapter.applySnapshot(files: data, animated: false)
    } catch {
      
    }
  }
  
  private func configureNavigationItem() {
    let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(add))
    add.tintColor = UIColor.basicBlack
    let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(search))
    search.tintColor = UIColor.basicBlack
    self.navigationItem.rightBarButtonItems = [
      add,
      search
    ]
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

extension LibraryController: LibraryTableViewAdapterDelegate {
  func libraryTableView(didUpdateItems itemCount: Int) {
    let hasData = itemCount > 0
    mainView.updateEmptyView(isHidden: hasData)
  }
  
  func libraryTableView(didSelectFileItem file: any FileItemProtocol) {
    print(file.name)
  }
}

extension LibraryController: LibraryOptionsBottomSheetDelegate {
  public func presentToDocumentPickerController() {
    let documentController = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
    documentController.delegate = self
    present(documentController, animated: true)
  }
  
  public func presentToCreateFolderController() {
    let createFolderModal = LibraryCreateFolderController()
    createFolderModal.dismissCallback = {
      return self.fetch()
    }
    present(createFolderModal, animated: false)
  }
}

extension LibraryController: UIDocumentPickerDelegate {
  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    let fileRepository = FileManagerRepository.shared
    
    if let selectedFileURL = urls.first {
      
      let fileName = selectedFileURL.lastPathComponent
      if let encodedString = fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
         let url = URL(string: encodedString),
         let _ = url.lastPathComponent.removingPercentEncoding {
        
        if let fileData = try? Data(contentsOf: selectedFileURL) {
          let type = checkFileType(for: fileData)
          switch type {
          case .txt:
            do {
              print(selectedFileURL)
              try fileRepository.saveFile(data: fileData, to: fileName)
              fetch()
            } catch FileManagerRepositoryError.fileAlreadyExists {
              let alertController = UIAlertController(title: nil, message: "현재 디렉토리에 같은 이름의 파일이 존재합니다.", preferredStyle: .alert)
              let alertAction = UIAlertAction(title: "확인", style: .cancel)
              alertController.addAction(alertAction)
              present(alertController, animated: true)
            } catch FileManagerRepositoryError.writeFailed {
              let alertController = UIAlertController(title: "파일 불러오기 실패", message: "개발자에게 문의하세요", preferredStyle: .alert)
              let alertAction = UIAlertAction(title: "확인", style: .cancel)
              alertController.addAction(alertAction)
            } catch {
              let alertController = UIAlertController(title: "알 수 없는 오류", message: "개발자에게 문의하세요", preferredStyle: .alert)
              let alertAction = UIAlertAction(title: "확인", style: .cancel)
              alertController.addAction(alertAction)
            }
          case .pdf:
            print("pdf file")
          case .unknown:
            print("unkown file")
          }
        }
      }
    }
  }
  
  public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print("사용자가 취소함")
  }
}

func checkFileType(for data: Data) -> FileType {
  if String(data: data, encoding: .utf8) != nil {
    return .txt
  }
  
  let pdfMagicNumber = Data([0x25, 0x50, 0x44, 0x46, 0x2D]) // %PDF-
  
  if data.prefix(pdfMagicNumber.count) == pdfMagicNumber {
    return .pdf
  }
  
  return .unknown
}

enum FileType {
  case pdf
  case txt
  case unknown
}
