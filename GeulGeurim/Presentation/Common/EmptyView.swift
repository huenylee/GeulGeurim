//
//  EmptyView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 1.06.2024.
//

import UIKit
import SnapKit

public class EmptyView: BaseView {
  private let bookImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "text.book.closed.fill")
    imageView.tintColor = UIColor.gray300
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let emptyMessageLabel: UILabel = {
    let label = UILabel()
    label.font = Font.T4_Regular
    label.textColor = UIColor.gray600
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  public var message: String? {
    didSet {
      emptyMessageLabel.text = message
      layoutIfNeeded()
    }
  }
  
  public override func configureUI() {
    addSubview(bookImageView)
    bookImageView.snp.makeConstraints {
      $0.size.equalTo(45)
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    addSubview(emptyMessageLabel)
    emptyMessageLabel.snp.makeConstraints {
      $0.top.equalTo(bookImageView.snp.bottom).offset(23)
      $0.horizontalEdges.equalToSuperview()
    }
  }
}
