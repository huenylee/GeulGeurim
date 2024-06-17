//
//  LibraryCreateFolderView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 4.06.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class LibraryCreateFolderView: BaseView, RxTouchable, RxBindable {
  private let headerView: UIView = UIView()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.T3_SemiBold
    label.textColor = .basicBlack
    label.text = "폴더 생성"
    return label
  }()
  
  private let createButton: UIButton = {
    let label = UIButton()
    var config = UIButton.Configuration.plain()
    var titleAttr = AttributedString.init("생성")
    titleAttr.font = Font.T3_SemiBold
    config.attributedTitle = titleAttr
    config.baseForegroundColor = .primaryNormal
    config.titlePadding = 0
    label.configuration = config
    return label
  }()
  
  private let dividerView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray100
    return view
  }()
  
  private let bodyView: UIView = UIView()
  
  public let textField: UITextField = {
    let field = UITextField()
    field.autocorrectionType = .no
    field.placeholder = "폴더 이름을 입력하세요."
    return field
  }()
  
  public var touchEventRelay: PublishRelay<String> = .init()
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    bind()
  }
  
  public override func configureUI() {
    addSubview(headerView)
    headerView.addSubview(titleLabel)
    headerView.addSubview(createButton)
    
    addSubview(dividerView)
    addSubview(bodyView)
    bodyView.addSubview(textField)
    
    headerView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(50)
    }
    
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    createButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    bodyView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(28)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(25)
    }
  }
  
  public func bind() {
    textField.rx.text
      .bind(with: self) { owner, text in
        let isEnabled: Bool = {
          guard let text = text else { return false }
          let trimmedText = text.trimmingCharacters(in: .whitespaces)
          return !trimmedText.isEmpty
        }()
        owner.createButton.isEnabled = isEnabled
      }
      .disposed(by: disposeBag)
    
    createButton.rx.tap
      .compactMap { self.textField.text }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}
