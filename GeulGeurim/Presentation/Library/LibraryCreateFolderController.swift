//
//  LibraryCreateFolderController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 4.06.2024.
//

import UIKit
import SnapKit
import RxSwift

public final class LibraryCreateFolderController: BaseController, RxBindable {
  private let modalView: LibraryCreateFolderView = {
    let view = LibraryCreateFolderView()
    view.backgroundColor = .basicWhite
    view.layer.cornerRadius = 16
    view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    return view
  }()
  
  private var modalTopConstraint: Constraint?
  private let disposeBag: DisposeBag = DisposeBag()
  public var dismissCallback: (() -> ())?
  
  public override init() {
    super.init()
    
    self.modalPresentationStyle = .overFullScreen
    bind()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    modalView.textField.becomeFirstResponder()
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
    modalView.touchEventRelay
      .bind(with: self) { owner, folderName in
        let fileRepository = FileManagerRepository.shared
        do {
          try fileRepository.createDirectory(name: folderName)
          owner.animateDismiss(completion: owner.dismissCallback)
        } catch FileManagerRepositoryError.directoryAlreadyExists {
          print("이미 같은거 있어~")
        } catch {
          print("뭔진 모르겠지만 안됨")
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func animatePresentation() {
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.view.alpha = 1
      self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      self?.view.layoutIfNeeded()
    }
  }
  
  private func animateDismiss(completion: (() -> ())? = nil) {
    UIView.animate(withDuration: 0.2) { [weak self] in
      self?.view.backgroundColor = .clear
      self?.view.layoutIfNeeded()
      self?.view.endEditing(true)
    } completion: { [weak self] bool in
      self?.dismiss(animated: false)
      completion?()
    }
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

extension LibraryCreateFolderController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // 터치가 bottomSheetView 내에서 발생한 경우 false 반환
    return !modalView.frame.contains(touch.location(in: view))
  }
}
