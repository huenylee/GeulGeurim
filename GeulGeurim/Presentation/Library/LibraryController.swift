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
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewAdapter.delegate = self
    tableViewAdapter.applySnapshot(files: [])
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
    present(optionBottomSheetController, animated: false)
  }
}

extension LibraryController: LibraryTableViewAdapterDelegate {
  func libraryTableView(didUpdateItems itemCount: Int) {
    let hasData = itemCount > 0
    mainView.updateEmptyView(isHidden: hasData)
  }
  
  func libraryTableView(didSelectFileItem file: FileItemWrapper) {
    
  }
}
