//
//  LibraryTableViewAdapter.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 2.06.2024.
//

import UIKit
import RxSwift

protocol LibraryTableViewAdapterDelegate: AnyObject {
  func libraryTableView(didUpdateItems itemCount: Int)
  func libraryTableView(didSelectFolderItem file: any FileProtocol)
  func libraryTableView(didSelectContentItem file: any FileProtocol)
  func libraryTableView(didLongPressOnItem file: any FileProtocol)
}

public final class LibraryTableViewAdapter: NSObject {
  typealias DiffableDataSource = UITableViewDiffableDataSource<Int, FileWrapper>
  
  private var tableView: UITableView
  private var diffableDataSource: DiffableDataSource?
  weak var delegate: LibraryTableViewAdapterDelegate?
  
  public init(tableView: UITableView) {
    self.tableView = tableView
    super.init()
    self.registerCells()
    self.configureDataSource()
  }
  
  private func configureDataSource() {
    diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier -> UITableViewCell? in
      let cell = self.configureCell(for: tableView, at: indexPath, with: itemIdentifier)
      return cell
    })
  }

  private func registerCells() {
    tableView.register(ContentCell.self, forCellReuseIdentifier: ContentCell.identifier)
    tableView.register(FolderCell.self, forCellReuseIdentifier: FolderCell.identifier)
  }

  private func configureCell(for tableView: UITableView, at indexPath: IndexPath, with itemIdentifier: FileWrapper) -> UITableViewCell? {
    switch itemIdentifier.file.type {
    case .content:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.identifier, for: indexPath) as? ContentCell else { return nil }
      cell.configureCell(data: itemIdentifier.file)
      cell.touchEventRelay
        .subscribe(with: self) { owner, type in
          switch type {
          case .actionMenu(let file):
            owner.delegate?.libraryTableView(didLongPressOnItem: file)
          case .open(let file):
            owner.delegate?.libraryTableView(didSelectContentItem: file)
          }
        }
        .disposed(by: cell.disposeBag)
      return cell
    case .folder:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else { return nil }
      cell.configureCell(data: itemIdentifier.file)
      cell.touchEventRelay
        .subscribe(with: self) { owner, type in
          switch type {
          case .actionMenu(let file):
            owner.delegate?.libraryTableView(didLongPressOnItem: file)
          case .open(let file):
            owner.delegate?.libraryTableView(didSelectFolderItem: file)
          }
        }
        .disposed(by: cell.disposeBag)
      return cell
    }
  }
  
  public func applySnapshot(files: [FileWrapper], animated: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, FileWrapper>()
    snapshot.appendSections([0])
    snapshot.appendItems(files, toSection: 0)
    diffableDataSource?.defaultRowAnimation = .automatic
    diffableDataSource?.apply(snapshot, animatingDifferences: animated)
    delegate?.libraryTableView(didUpdateItems: snapshot.numberOfItems)
  }
}

