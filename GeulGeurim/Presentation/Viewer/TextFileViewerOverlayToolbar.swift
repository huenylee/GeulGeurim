//
//  TextFileViewerOverlayToolbar.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 24.06.2024.
//

import UIKit
import RxSwift
import RxGesture

public protocol TextFileViewerOverlayToolbarDelegate: AnyObject {
  func backButtonTapped()
  func searchButtonTapped()
  func settingButtonTapped()
}

public final class TextFileViewerOverlayToolbar: BaseView {
  private let statusBarBackground: UIView = UIView()
  private let toolbarContainer: UIView = UIView()
  public weak var delegate: TextFileViewerOverlayToolbarDelegate?
  
  private let backButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
    let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
    button.setImage(image, for: .normal)
    button.tintColor = UIColor.basicBlack
    return button
  }()
  
  private let titleLabel: UILabel = {
    let view = UILabel()
    view.font = Font.T1_Regular
    view.textColor = UIColor.basicBlack
    return view
  }()
  
  private let searchButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
    let image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)
    button.setImage(image, for: .normal)
    button.tintColor = UIColor.basicBlack
    return button
  }()
  
  private let settingButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
    let image = UIImage(systemName: "textformat", withConfiguration: imageConfig)
    button.setImage(image, for: .normal)
    button.tintColor = UIColor.basicBlack
    return button
  }()
  
  private let dividerLine: UIView = {
    let view = UIView()
    view.backgroundColor = .gray200
    return view
  }()
  
  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)

    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
  }
  
  @objc func backButtonTapped() {
    delegate?.backButtonTapped()
  }
  
  @objc func searchButtonTapped() {
    delegate?.searchButtonTapped()
  }
  
  @objc func settingButtonTapped() {
    delegate?.settingButtonTapped()
  }
  
  public override func configureUI() {
    statusBarBackground.backgroundColor = .white
    toolbarContainer.backgroundColor = .white
    
    addSubview(statusBarBackground)
    statusBarBackground.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
    }
    
    addSubview(toolbarContainer)
    toolbarContainer.snp.makeConstraints {
      $0.top.equalTo(statusBarBackground.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    toolbarContainer.addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(20)
      $0.size.equalTo(25)
      $0.centerY.equalToSuperview()
    }
    
    toolbarContainer.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(15)
      $0.centerY.equalToSuperview()
//      $0.trailing.lessThanOrEqualTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
    }
  
    toolbarContainer.addSubview(settingButton)
    settingButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.size.equalTo(25)
      $0.centerY.equalToSuperview()
    }
    
    toolbarContainer.addSubview(searchButton)
    searchButton.snp.makeConstraints {
      $0.trailing.equalTo(settingButton.snp.leading).offset(-15)
      $0.size.equalTo(25)
      $0.centerY.equalToSuperview()
    }
    
    
    addSubview(dividerLine)
    dividerLine.snp.makeConstraints {
      $0.top.equalTo(toolbarContainer.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(0.7)
    }
  }
}
