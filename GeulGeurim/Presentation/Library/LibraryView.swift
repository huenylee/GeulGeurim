//
//  LibraryView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit
import SnapKit

public final class LibraryView: BaseView, EmptyViewRepresnetable {
  private let headerView: UIView = UIView()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "보관함"
    label.font = Font.Pretendard(.Bold).of(size: 34)
    return label
  }()
  
  public let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = 75
    tableView.separatorStyle = .none
    return tableView
  }()
  
  public let emptyView: UIView = {
    let view = EmptyView()
    view.message = """
    보관함이 비어있어요.
    오른쪽 상단 + 버튼을 눌러서
    파일을 추가해보세요.
    """
    return view
  }()
  
  public override func configureUI() {
    addSubview(headerView)
    headerView.addSubview(titleLabel)
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
}
