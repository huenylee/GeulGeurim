//
//  EmptyStateTableView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 11.06.2024.
//

import UIKit

open class EmptyStateTableView: UITableView, EmptyViewRepresnetable {
  public var emptyView: UIView = {
    let view = EmptyView()
    view.message = """
    보관함이 비어있어요.
    오른쪽 상단 + 버튼을 눌러서
    파일을 추가해보세요.
    """
    return view
  }()
  
  public override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

