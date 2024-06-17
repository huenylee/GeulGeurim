//
//  FolderCell.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 2.06.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

public final class FolderCell: PressableCell {
  private let iconView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "folder.fill")
    imageView.tintColor = UIColor.secondaryNormal
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.T4_Regular
    label.textColor = UIColor.black
    return label
  }()
  
  private let createdDateLabel: UILabel = {
    let label = UILabel()
    label.font = Font.B1_Regular
    label.textColor = UIColor.gray500
    return label
  }()
  
  private let fileCountLabel: UILabel = {
    let label = UILabel()
    label.font = Font.B1_Regular
    label.textColor = UIColor.gray500
    return label
  }()
  
  private let dividerLineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.gray200
    return view
  }()
  
  private let arrowRightImageView: UIImageView = {
    let image = UIImage(named: "ArrowRight")
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    view.image = image
    return view
  }()
  
  public enum TouchEventType {
    case open(any FileProtocol)
    case actionMenu(any FileProtocol)
  }
  
  public let touchEventRelay: PublishRelay<TouchEventType> = .init()
  private var file: (any FileProtocol)?
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    createdDateLabel.text = nil
    fileCountLabel.text = nil
  }

  public func configureCell(data: any FileProtocol) {
    file = data
    selectionStyle = .none
    setupUIWithData(data: data)
    setupConstraints()
    
    touchableClosure = { [weak self] type in
      guard let file = self?.file else { return }
      
      switch type {
      case .long:
        self?.touchEventRelay.accept(.actionMenu(file))
      case .short:
        self?.touchEventRelay.accept(.open(file))
      }
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    contentView.addSubview(iconView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(createdDateLabel)
    contentView.addSubview(fileCountLabel)
    contentView.addSubview(dividerLineView)
    contentView.addSubview(arrowRightImageView)
    
    iconView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(23)
      $0.size.equalTo(24)
      $0.centerY.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(iconView.snp.trailing).offset(21)
      $0.top.equalToSuperview().offset(17)
      $0.trailing.lessThanOrEqualToSuperview().offset(-45)
    }
    
    createdDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalTo(titleLabel)
    }
    
    fileCountLabel.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel)
      $0.leading.equalTo(createdDateLabel.snp.trailing).offset(8)
    }
    
    dividerLineView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(1)
    }
    
    
    arrowRightImageView.snp.makeConstraints {
      $0.size.equalTo(14)
      $0.trailing.equalToSuperview().offset(-17)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func setupUIWithData(data: any FileProtocol) {
    titleLabel.text = data.name
    createdDateLabel.text = data.createdDate.toString(pattern: "yyyy. MM. dd")
    guard let folder = data as? FolderFile else { return }
    fileCountLabel.text = "파일 \(folder.subfilesCount)개"
  }
}
