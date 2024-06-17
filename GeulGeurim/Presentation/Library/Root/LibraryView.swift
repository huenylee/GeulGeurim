//
//  LibraryView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit
import SnapKit

public final class LibraryView: BaseView {
  private let headerView: UIView = UIView()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "보관함"
    label.font = Font.Pretendard(.Bold).of(size: 34)
    return label
  }()
  
  public let tableView: EmptyStateTableView = {
    let tableView = EmptyStateTableView(frame: .zero, style: .plain)
    tableView.rowHeight = 75
    tableView.separatorStyle = .none
    return tableView
  }()
  
  public override func configureUI() {
    addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
