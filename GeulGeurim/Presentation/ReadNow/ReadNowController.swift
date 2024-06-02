//
//  ReadNowController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit

public final class ReadNowController: BaseController {
  private let mainView: ReadNowView = ReadNowView()
  private let tabBarItemType: TabBarItemType = .readNow
  private lazy var tableViewAdapter: ReadNowTableViewAdapter = ReadNowTableViewAdapter(tableView: mainView.tableView)
  
  public override func loadView() {
    super.loadView()
    view = mainView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    tableViewAdapter.delegate = self
    
//    tableViewAdapter.applySnapshot(files: [
//      FileItemWrapper(ContentItem(fileName: "달빛조각사 16권", createdDate: Date(), fileSize: 1)),
//      FileItemWrapper(ContentItem(fileName: "달빛조각사 17권", createdDate: Date(), fileSize: 1)),
//      FileItemWrapper(ContentItem(fileName: "달빛조각사 18권", createdDate: Date(), fileSize: 1)),
//      FileItemWrapper(ContentItem(fileName: "달빛조각사 19권", createdDate: Date(), fileSize: 1))
//    ])
  }
}

extension ReadNowController: ReadNowTableViewAdapterDelegate {
  func readNowTableView(didUpdateItems itemCount: Int) {
    mainView.emptyViewIsHidden = itemCount > 0
  }
  
  func readNowTableView(didSelectFileItem file: FileItemWrapper) {
  
  }
}
 
