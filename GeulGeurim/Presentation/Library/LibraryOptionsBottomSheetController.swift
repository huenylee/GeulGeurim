//
//  LibraryOptionsBottomSheetController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 2.06.2024.
//

import UIKit
import SnapKit
import RxSwift

public protocol LibraryOptionsBottomSheetDelegate: AnyObject {
  func presentToDocumentPickerController()
  func presentToCreateFolderController()
}

public final class LibraryOptionsBottomSheetController: BaseController, Bindable {
  private let bottomSheetView: LibraryOptionsBottomSheetView = {
    let view = LibraryOptionsBottomSheetView()
    view.layer.cornerRadius = 16
    view.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    return view
  }()
  
  private var bottomSheetTopConstraint: Constraint?
  private let disposeBag: DisposeBag = DisposeBag()
  public weak var delegate: LibraryOptionsBottomSheetDelegate?
  
  public override init() {
    super.init()
    
    self.modalPresentationStyle = .overFullScreen
    bind()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    animatePresentation()
  }
  
  public override func configureUI() {
    view.alpha = 0
    view.addSubview(bottomSheetView)
    
    bottomSheetView.snp.makeConstraints {
      bottomSheetTopConstraint = $0.top.equalTo(view.snp.bottom).constraint
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
    
    setupTapGesture()
    setupSwiftGesture()
  }
  
  public func bind() {
    bottomSheetView.touchEventRelay
      .bind(with: self) { owner, type in
        owner.animateDismiss {
          switch type {
          case .createFolder:
            owner.delegate?.presentToCreateFolderController()
          case .download:
            owner.delegate?.presentToDocumentPickerController()
          }
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func animatePresentation() {
    bottomSheetTopConstraint?.update(offset: -194)
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.alpha = 1
      self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      self?.view.layoutIfNeeded()
    }
  }
  
  private func animateDismiss(completion: (() -> ())? = nil) {
    bottomSheetView.snp.remakeConstraints {
      $0.top.equalTo(view.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.backgroundColor = .clear
      self?.view.layoutIfNeeded()
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
  
  private func setupSwiftGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    view.addGestureRecognizer(panGesture)
  }
  
  @objc func handleBackgroundTap() {
    animateDismiss()
  }
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let velocity = gesture.velocity(in: view)
    
    switch gesture.state {
    case .changed:
      let offset = max(-194, -194 + translation.y)
      bottomSheetTopConstraint?.update(offset: offset)
      
      let progress = min(max(translation.y / 194, 0), 1)
      let alpha = 0.5 * (1 - progress)
      view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
      
      view.layoutIfNeeded()
    case .ended:
      // `bottomSheetView`의 현재 위치 확인
      guard let currentOffset = bottomSheetTopConstraint?.layoutConstraints.first?.constant else { return }
      if velocity.y > 1000 {
        animateDismiss()
      } else if currentOffset > -194 / 2 {
        animateDismiss()
      } else {
        animatePresentation()
      }
    default:
      break
    }
  }
}

extension LibraryOptionsBottomSheetController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // 터치가 bottomSheetView 내에서 발생한 경우 false 반환
    return !bottomSheetView.frame.contains(touch.location(in: view))
  }
}
