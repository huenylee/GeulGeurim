//
//  ContentCell.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 28.05.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

public final class ContentCell: PressableCell {
  private let containerView: UIControl = UIControl()
  private let iconView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "doc.text.fill")
    imageView.tintColor = UIColor.gray700
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
  
  private let fileSizeLabel: UILabel = {
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
  
  
  public let touchEventRelay: PublishRelay<any FileItemProtocol> = .init()
  private var file: (any FileItemProtocol)?
  
  public override func prepareForReuse() {
    titleLabel.text = nil
    createdDateLabel.text = nil
    fileSizeLabel.text = nil
  }
  
  public func configureCell(data: any FileItemProtocol) {
    file = data
    selectionStyle = .none
    setupUIWithData(data: data)
    setupConstraints()
    
    touchableClosure = { [weak self] in
      guard let file = self?.file else { return }
      self?.touchEventRelay.accept(file)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    contentView.addSubview(iconView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(createdDateLabel)
    contentView.addSubview(fileSizeLabel)
    contentView.addSubview(dividerLineView)
    
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
    
    fileSizeLabel.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel)
      $0.leading.equalTo(createdDateLabel.snp.trailing).offset(8)
    }
    
    dividerLineView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(1)
    }
  }
  
  private func setupUIWithData(data: any FileItemProtocol) {
    titleLabel.text = data.name
    createdDateLabel.text = data.createdDate.toString(pattern: "yyyy. MM. dd")
    guard let content = data as? ContentItem else { return }
    fileSizeLabel.text = convertBytesToKB(bytes: content.fileSize)
  }
  
  func convertBytesToKB(bytes: Int64) -> String {
    let kb = Double(bytes) / 1024 // 바이트를 KB로 변환
    let roundedKB = round(kb * 10) / 10 // 소숫점 첫째 자리까지 반올림
    let formattedKB = String(format: "%.1f KB", roundedKB) // 문자열 형식으로 변환

    return formattedKB
  }
}
