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

public final class ContentCell: UITableViewCell {
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
  private var disposeBag: DisposeBag = DisposeBag()
  private var file: (any FileItemProtocol)?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    bind()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    bind()
  }
  
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
  }
  
  func bind() {
    containerView.rx.controlEvent(.touchDown)
      .subscribe(with: self) { owner, _ in
        owner.press()
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
      containerView.rx.controlEvent(.touchDragExit).map { _ in Void() },
      containerView.rx.controlEvent(.touchCancel).map { _ in Void() }
    )
    .bind(with: self) { owner, _ in
      owner.unpress()
    }
    .disposed(by: disposeBag)
    
    containerView.rx.controlEvent(.touchUpInside)
      .delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
      .bind(with: self) { owner, _ in
        owner.unpress()
        guard let file = owner.file else { return }
        owner.touchEventRelay.accept(file)
      }
      .disposed(by: disposeBag)
  }
  
  private func setupConstraints() {
    contentView.addSubview(containerView)
    contentView.addSubview(iconView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(createdDateLabel)
    contentView.addSubview(fileSizeLabel)
    contentView.addSubview(dividerLineView)
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
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
    createdDateLabel.text = "2024. 05. 28."
    fileSizeLabel.text = "1KB"
  }
  
  enum pressEventType {
    case press
    case unpress
  }
}

extension ContentCell: Pressable {
  public func press() {
    contentView.backgroundColor = .gray100
  }
  
  public func unpress() {
    contentView.backgroundColor = .basicWhite
  }
}
