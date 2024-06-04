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
    
    let fileRepository = FileManagerRepository.shared
    do {
      let files = try fileRepository.listFiles()
      let entities = files.compactMap { $0.todomain() }
      let data = entities.map { FileItemWrapper($0) }
      tableViewAdapter.applySnapshot(files: data, animated: false)
    } catch {
      
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewAdapter.delegate = self
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
  
  func libraryTableView(didSelectFileItem file: FileItemWrapper) {
    print("잇힝~")
  }
}

extension LibraryController: LibraryOptionsBottomSheetDelegate {
  public func presentToDocumentPickerController() {
    let documentController = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
    documentController.delegate = self
    present(documentController, animated: true)
  }
  
  public func presentToCreateFolderController() {
    print("폴더 컨트롤러로 보내라~")
  }
}

extension LibraryController: UIDocumentPickerDelegate {
  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    let fileRepository = FileManagerRepository.shared
    
    if let selectedFileURL = urls.first {
      print("Selected file URL: \(selectedFileURL)")
      
      let fileName = selectedFileURL.lastPathComponent
      if let encodedString = fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
         let url = URL(string: encodedString),
         let decodedString = url.lastPathComponent.removingPercentEncoding {
        print("Decoded file name: \(decodedString)")
        
        // 파일 데이터 가져오기
        if let fileData = try? Data(contentsOf: selectedFileURL) {
          let type = checkFileType(for: fileData)
          switch type {
          case .txt:
            print("txt 임~")
            do {
              try fileRepository.saveFile(data: fileData, to: fileName)
            } catch {
              print(error)
            }
          case .pdf:
            print("pdf 임~")
          case .unknown:
            print("모르는 확장자 에러처리.")
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
  // TXT 파일 확인
  if String(data: data, encoding: .utf8) != nil {
    // 일반적인 텍스트 파일이면 TXT 파일로 간주
    return .txt
  }
  
  // PDF 파일의 매직 넘버
  let pdfMagicNumber = Data([0x25, 0x50, 0x44, 0x46, 0x2D]) // %PDF-
  
  // PDF 파일 매직 넘버 확인
  if data.prefix(pdfMagicNumber.count) == pdfMagicNumber {
    return .pdf
  }
  
  // 나머지 파일은 알 수 없는 파일로 간주
  return .unknown
}

enum FileType {
  case pdf
  case txt
  case unknown
}
