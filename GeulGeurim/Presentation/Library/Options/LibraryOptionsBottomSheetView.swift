//
//  LibraryOptionsBottomSheetView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 2.06.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class BottomSheetRowView: BaseControl, RxTouchable, RxPressable, RxBindable {
  private let iconView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = UIColor.basicBlack
    return imageView
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    label.font = Font.Pretendard(.Regular).of(size: 17)
    return label
  }()
  
  public let touchEventRelay: PublishRelay<Void> = .init()
  private let disposeBag: DisposeBag = DisposeBag()
  
  init(title: String, icon: UIImage?) {
    label.text = title
    iconView.image = icon
    super.init(frame: .zero)
    configureUI()
    bind()
  }
  
  func configureUI() {
    addSubview(iconView)
    addSubview(label)
    
    iconView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(30)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(25)
    }
    
    label.snp.makeConstraints {
      $0.leading.equalTo(iconView.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
      $0.trailing.lessThanOrEqualToSuperview().offset(-71)
    }
  }
  
  public func bind() {
    self.rx.controlEvent(.touchDown)
      .bind(with: self) { owner, _ in
        owner.press()
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
      self.rx.controlEvent(.touchDragExit).map { _ in Void() },
      self.rx.controlEvent(.touchCancel).map { _ in Void() }
    )
    .bind(with: self) { owner, _ in
      owner.unpress()
    }
    .disposed(by: disposeBag)
    
    self.rx.controlEvent(.touchUpInside)
      .bind(with: self) { owner, _ in
        owner.unpress()
        owner.touchEventRelay.accept(())
      }
      .disposed(by: disposeBag)
  }
  
  public func press() {
    self.backgroundColor = .gray100
  }
  
  public func unpress() {
    self.backgroundColor = .basicWhite
  }
}

public final class LibraryOptionsBottomSheetView: BaseView, RxTouchable, RxBindable {
  private let downloadRowView: BottomSheetRowView = BottomSheetRowView(title: "다운로드", icon: UIImage(systemName: "icloud.and.arrow.down"))
  private let createFolderRowView: BottomSheetRowView = BottomSheetRowView(title: "폴더 생성", icon: UIImage(systemName: "folder.badge.plus"))
  
  public let touchEventRelay: PublishRelay<TouchEventType> = .init()
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override func configureUI() {
    super.configureUI()
    self.backgroundColor = UIColor.basicWhite
    setupDownloadRow()
    setupCreateFolderRow()
    bind()
  }
  
  private func setupDownloadRow() {
    addSubview(downloadRowView)
    downloadRowView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(29)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(55)
    }
  }
  
  private func setupCreateFolderRow() {
    addSubview(createFolderRowView)
    createFolderRowView.snp.makeConstraints {
      $0.top.equalTo(downloadRowView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(55)
    }
  }
  
  public func bind() {
    downloadRowView.touchEventRelay
      .map { .download }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    createFolderRowView.touchEventRelay
      .map { .createFolder }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  public enum TouchEventType {
    case download
    case createFolder
  }
}
