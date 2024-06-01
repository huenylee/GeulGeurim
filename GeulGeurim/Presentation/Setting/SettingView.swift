//
//  SettingView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit
import SnapKit

public final class SettingView: BaseView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "설정"
    label.font = Font.Pretendard(.Bold).of(size: 34)
    return label
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureUI()
  }
  
  public override func configureUI() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(self.safeAreaLayoutGuide)
    }
  }
}

