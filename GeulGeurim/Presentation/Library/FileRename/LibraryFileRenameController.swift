//
//  LibraryFileRenameController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 19.06.2024.
//

import UIKit
import SnapKit
import RxSwift

public final class LibraryFileRenameController: BaseController, RxBindable {
  private let modalView: ActionInputView = {
    let view = ActionInputView(title: "이름 변경", buttonTitle: "변경", placeholder: "파일 이름을 입력하세요.")
    view.backgroundColor = .basicWhite
    view.layer.cornerRadius = 16
    view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    return view
  }()
  private var modalTopConstraint: Constraint?
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override init() {
    super.init()
    
    self.modalPresentationStyle = .overFullScreen
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    modalView.textField.becomeFirstResponder()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animatePresentation()
  }
  
  public override func configureUI() {
    view.alpha = 0
    view.addSubview(modalView)
    
    modalView.snp.makeConstraints {
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
    }
    
    setupTapGesture()
  }
  
  public func bind() {

  }
  
  private func animatePresentation() {
    UIView.animate(withDuration: 0.15) { [weak self] in
      self?.view.alpha = 1
      self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      self?.view.layoutIfNeeded()
    }
  }
  
  private func animateDismiss(completion: (() -> ())? = nil) {
    UIView.animate(withDuration: 0.15) { [weak self] in
      self?.view.backgroundColor = .clear
      guard let self else { return }
      self.modalView.snp.remakeConstraints {
        $0.bottom.equalTo(self.view.snp.bottom).offset(self.modalView.frame.height)
        $0.horizontalEdges.equalToSuperview()
      }
      self.view.layoutIfNeeded()
    } completion: { [weak self] bool in
      self?.dismiss(animated: false)
      completion?()
    }
    view.endEditing(true)
  }
  
  private func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func handleBackgroundTap() {
    animateDismiss()
  }
}

extension LibraryFileRenameController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // 터치가 bottomSheetView 내에서 발생한 경우 false 반환
    return !modalView.frame.contains(touch.location(in: view))
  }
}
