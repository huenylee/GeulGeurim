//
//  ReadNowView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit
import SnapKit

public final class ReadNowView: BaseView {
  private let headerView: UIView = UIView()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "지금 읽기"
    label.font = Font.Pretendard(.Bold).of(size: 34)
    return label
  }()
  
  public let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = 75
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private let emptyView: EmptyView = {
    let view = EmptyView()
    view.message = """
    최근 읽은 파일이 없어요.
    보관함에서 텍스트 파일을 골라보세요!
    """
    return view
  }()
  
  public var emptyViewIsHidden: Bool = true {
    didSet {
      if oldValue != emptyViewIsHidden {
        updateEmptyView(isHidden: emptyViewIsHidden)
      }
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureUI()
    updateEmptyView(isHidden: false)
  }
  
  public override func configureUI() {
    addSubview(headerView)
    headerView.addSubview(titleLabel)
    addSubview(tableView)
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }
  
  private func updateEmptyView(isHidden: Bool) {
    if isHidden {
      emptyView.removeFromSuperview()
    } else {
      addSubview(emptyView)
      emptyView.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.equalTo(238)
        $0.height.equalTo(106)
      }
    }
  }
}
