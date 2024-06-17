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
    
    tableViewAdapter.applySnapshot(files: [])
  }
}

extension ReadNowController: ReadNowTableViewAdapterDelegate {
  func readNowTableView(didUpdateItems itemCount: Int) {
    let hasData = itemCount > 0
    mainView.updateEmptyView(isHidden: hasData)
  }
  
  func readNowTableView(didSelectFileItem file: FileWrapper) {
  
  }
}
 
