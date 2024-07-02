//
//  TextFileViewerOverlayNavigator.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 25.06.2024.
//

import UIKit
import RxSwift
import RxRelay

public protocol TextFileViewerOverlayNavigatorDelegate: AnyObject {
  func valueChanged(value: Int)
}

public final class TextFileViewerOverlayNavigator: BaseView {
  private let dividerLine: UIView = {
    let view = UIView()
    view.backgroundColor = .gray200
    return view
  }()
  
  private let navigatorContainer: UIView = UIView()
  private let pageSlider: UISlider = {
    let view = UISlider()
    view.thumbTintColor = UIColor.primaryNormal
    view.tintColor = .gray200
    view.minimumTrackTintColor = .gray200
    view.maximumTrackTintColor = .gray200
    return view
  }()
  private let pageLabel: UILabel = {
    let view = UILabel()
    view.font = Font.B1_SemiBold
    view.textColor = UIColor.basicBlack
    return view
  }()
  
  public weak var delegate: TextFileViewerOverlayNavigatorDelegate?
  public var lastPageIndex: Int = 1 {
    didSet {
      configureNavigator()
    }
  }
  public var currentPageIndex: Int = 1 {
    didSet {
      configureNavigator()
    }
  }
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  init() {
    super.init(frame: .zero)
    configureNavigator()
  }
  
  public override func configureUI() {
    backgroundColor = .basicWhite
    
    addSubview(dividerLine)
    dividerLine.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(0.7)
    }
    
    addSubview(navigatorContainer)
    navigatorContainer.backgroundColor = .basicWhite
    navigatorContainer.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(100)
      $0.top.equalTo(dividerLine.snp.bottom)
    }
    
    
    navigatorContainer.addSubview(pageSlider)
    pageSlider.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.horizontalEdges.equalToSuperview().inset(24)
    }
    
    navigatorContainer.addSubview(pageLabel)
    pageLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(pageSlider.snp.bottom).offset(14)
    }
  }
  
  private func bind() {
    pageSlider.rx.value
      .bind(with: self) { [weak self] owner, value in
        guard let self else { return }
        let currentIndex = calculateIndex(sliderValue: value, lastPageIndex: lastPageIndex)
        owner.currentPageIndex = max(currentIndex, 1)
        print("바뀌는 중: \(max(currentIndex, 1))")
      }
      .disposed(by: disposeBag)
    
    pageSlider.rx.value
      .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
      .bind(with: self) { [weak self] owner, value in
        guard let self else { return }
        let currentIndex = calculateIndex(sliderValue: value, lastPageIndex: lastPageIndex)
        print("바뀜: \(currentIndex)")
      }
      .disposed(by: disposeBag)
  }
  
  private func calculateIndex(sliderValue: Float, lastPageIndex: Int) -> Int {
    let currentIndex = Int(Float(lastPageIndex) * sliderValue)
    return max(currentIndex, 1)
  }
  
  public func configureNavigator() {
    pageLabel.text = "\(currentPageIndex)/\(lastPageIndex)"
  }
}
