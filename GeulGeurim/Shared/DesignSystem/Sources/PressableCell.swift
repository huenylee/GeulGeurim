//
//  PressableCell.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 7.06.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

public class PressableCell: UITableViewCell {
  private let containerView: UIControl = UIControl()
  public var touchableClosure: (() -> ())?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupConstraints()
    bind()
  }

  public var disposeBag: DisposeBag = DisposeBag()
  
  func setupConstraints() {
    contentView.addSubview(containerView)
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
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
      .delay(.milliseconds(70), scheduler: MainScheduler.asyncInstance)
      .bind(with: self) { owner, _ in
        owner.unpress()
      }
      .disposed(by: disposeBag)
    
    containerView.rx.controlEvent(.touchUpInside)
      .bind(with: self) { owner, _ in
        owner.touchableClosure?()
      }
      .disposed(by: disposeBag)
  }
}

extension PressableCell: RxPressable {
  enum pressEventType {
    case press
    case unpress
  }
  
  public func press() {
    contentView.backgroundColor = .gray100
  }
  
  public func unpress() {
    contentView.backgroundColor = .basicWhite
  }
}

