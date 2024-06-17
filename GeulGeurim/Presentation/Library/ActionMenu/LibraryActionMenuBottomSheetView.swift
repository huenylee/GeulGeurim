//
//  LibraryActionMenuBottomSheetView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 16.06.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class LibraryActionMenuBottomSheetView: BaseView, RxTouchable, RxBindable {
  private let renameRowView: BottomSheetRowView = BottomSheetRowView(title: "이름 수정", icon: UIImage(systemName: "pencil.line"))
  private let deleteRowView: BottomSheetRowView = BottomSheetRowView(title: "삭제", icon: UIImage(systemName: "trash"))
  
  public let touchEventRelay: PublishRelay<TouchEventType> = .init()
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override func configureUI() {
    super.configureUI()
    self.backgroundColor = UIColor.basicWhite
    
    setupRenameRow()
    setupDeleteRow()
    bind()
  }
  
  private func setupRenameRow() {
    addSubview(renameRowView)
    renameRowView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(29)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(55)
    }
  }
  
  private func setupDeleteRow() {
    addSubview(deleteRowView)
    deleteRowView.snp.makeConstraints {
      $0.top.equalTo(renameRowView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(55)
    }
  }
  
  public func bind() {
    renameRowView.touchEventRelay
      .map { .rename }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    deleteRowView.touchEventRelay
      .map { .delete }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  public enum TouchEventType {
    case rename
    case delete
  }
}
