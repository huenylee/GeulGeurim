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
  private var ignoreTouchUp: Bool?
  
  public var touchableClosure: ((TouchUpType) -> ())?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
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
    disposeBag = DisposeBag()
    
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
      .filter { [weak self] in
        guard let self,
              let ignoreTouchUp = self.ignoreTouchUp else { return true }
        return ignoreTouchUp
      }
      .do { [weak self] _ in
        self?.touchableClosure?(.short)
      }
      .delay(.milliseconds(70), scheduler: MainScheduler.asyncInstance)
      .bind(with: self) { owner, _ in
        owner.unpress()
      }
      .disposed(by: disposeBag)
    
//    containerView.rx.controlEvent(.touchUpInside)
//      .filter { [weak self] in
//        guard let self,
//              let ignoreTouchUp = self.ignoreTouchUp else { return false }
//        return ignoreTouchUp
//      }
//      .bind(with: self) { owner, _ in
//        owner.touchableClosure?(.short)
//      }
//      .disposed(by: disposeBag)
    
    let longPressRecognizer = UILongPressGestureRecognizer()
    longPressRecognizer.minimumPressDuration = 0.7
    containerView.addGestureRecognizer(longPressRecognizer)
    
    longPressRecognizer.rx.event
      .filter { $0.state == .began }
      .bind(with: self) { owner, _ in
        owner.ignoreTouchUp = false
        owner.touchableClosure?(.long)
      }
      .disposed(by: disposeBag)
    
    longPressRecognizer.rx.event
      .filter { $0.state == .ended || $0.state == .cancelled }
      .subscribe(with: self) { owner, _ in
        owner.ignoreTouchUp = true
      }
      .disposed(by: disposeBag)
  }
}

extension PressableCell: RxPressable {
  public enum TouchUpType {
    case short
    case long
  }
  
  public func press() {
    contentView.backgroundColor = .gray100
  }
  
  public func unpress() {
    contentView.backgroundColor = .basicWhite
  }
}

