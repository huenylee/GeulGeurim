//
//  TextFileViewerController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 20.06.2024.
//

import UIKit
import RxSwift
import RxGesture
import ReactorKit

public final class TextFileViewerController: BaseController, ReactorKit.View {
  private let overlayToolbar: TextFileViewerOverlayToolbar = {
    let view = TextFileViewerOverlayToolbar()
    view.alpha = 0
    return view
  }()
  private let overlayNavigator: TextFileViewerOverlayNavigator = {
    let view = TextFileViewerOverlayNavigator()
    view.alpha = 0
    return view
  }()
  
  private lazy var scrollViewer: TextFileScrollViewerView = TextFileScrollViewerView(config: config)
  private lazy var pageViewer: TextFilePageViewerController = TextFilePageViewerController(config: config)
  private let file: ContentFile
  private let config = TextViewerConfig(
    font: UIFont.systemFont(ofSize: 20),
    lineHeight: 1.5,
    textColor: UIColor.basicBlack,
    textAlignment: .natural,
    firstLineHeadIndent: 10,
    bounds: CGSize(width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height),
    padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  )
  
  public var disposeBag: DisposeBag = DisposeBag()
  private var isStatusBarHidden: Bool = false
  
  public override var prefersStatusBarHidden: Bool {
    return isStatusBarHidden
  }
  
  required init(reactor: TextFileViewerReactor, file: ContentFile) {
    defer {
      self.reactor = reactor
      self.overlayToolbar.title = file.name
      reactor.action.onNext(.loadViewer(file))
    }
    
    self.file = file
    super.init()
  }
  
  deinit {
    print("메모리 해제")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public func bind(reactor: TextFileViewerReactor) {
    self.view.rx.tapGesture { gesture, delegate in
      delegate.simultaneousRecognitionPolicy = .never
    }
    .when(.recognized)
    .subscribe(with: self) { [weak self] owner, gesture in
      guard let self else { return }
      self.toggleOverlay()
    }
    .disposed(by: disposeBag)
    
    reactor.state
      .map(\.file)
      .bind(with: self) { [unowned self] owner, file in
        guard let file,
              let mode = self.reactor?.currentState.mode else { return }
        
        self.initializeViewer()
        
        switch mode {
        case .pageMode:
          self.setPageViewer(file: file)
        case .scrollMode:
          self.setScrollViewer(file: file)
        }
        
        self.bringToFront()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.mode)
      .bind(with: self) { [unowned self] owner, mode in
        self.initializeViewer()
        self.toggleViewer(mode: mode)
        self.bringToFront()
      }
      .disposed(by: disposeBag)
  }
  
  public override func configureUI() {
    super.configureUI()
    
    self.isStatusBarHidden = true
    
    view.addSubview(overlayToolbar)
    overlayToolbar.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
    overlayToolbar.delegate = self
    
    view.addSubview(overlayNavigator)
    overlayNavigator.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
    overlayNavigator.configureNavigator()
  }
  
  private func initializeViewer() {
    pageViewer.view.removeFromSuperview()
    pageViewer.removeFromParent()
    scrollViewer.removeFromSuperview()
  }
  
  private func setPageViewer(file: ContentFile) {
    self.addChild(pageViewer)
    view.addSubview(pageViewer.view)
    
    pageViewer.delegate = self
    pageViewer.content = file.formattedContent
  }
  
  private func setScrollViewer(file: ContentFile) {
    view.addSubview(scrollViewer)
    scrollViewer.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    scrollViewer.file = file
    scrollViewer.delegate = self
    view.layoutIfNeeded()
  }
  
  private func bringToFront() {
    self.view.bringSubviewToFront(overlayToolbar)
    self.view.bringSubviewToFront(overlayNavigator)
  }
  
  
  private func toggleViewer(mode: TextFileViewerMode) {
    initializeViewer()
    switch mode {
    case .pageMode:
      setPageViewer(file: file)
    case .scrollMode:
      setScrollViewer(file: file)
    }
  }
  
  private func toggleOverlay() {
    self.setOverlayVisibility(hidden: self.overlayToolbar.alpha == 1)
  }
  
  private func setOverlayVisibility(hidden: Bool) {
    self.isStatusBarHidden = hidden
    UIView.animate(withDuration: 0.16) {
      self.setNeedsStatusBarAppearanceUpdate()
      self.overlayToolbar.alpha = hidden ? 0 : 1
      self.overlayNavigator.alpha = hidden ? 0 : 1
    }
  }
}

extension TextFileViewerController: UITextViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    setOverlayVisibility(hidden: true)
  }
}

extension TextFileViewerController: UIPageViewControllerDelegate {
  public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    self.setOverlayVisibility(hidden: true)
  }
}

extension TextFileViewerController: TextFileViewerOverlayToolbarDelegate {
  public func backButtonTapped() {
    dismiss(animated: true)
  }
  
  public func searchButtonTapped() {
    guard let reactor else { return }
    let currentMode = reactor.currentState.mode
    reactor.action.onNext(.changeMode( currentMode == .pageMode ? .scrollMode : .pageMode))
  }
  
  public func settingButtonTapped() {
    print("설정")
  }
}
