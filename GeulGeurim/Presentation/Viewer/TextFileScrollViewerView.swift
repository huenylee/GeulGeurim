//
//  TextFileScrollViewerView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 20.06.2024.
//

import UIKit

public final class TextFileScrollViewerView: BaseView {
  private let textView: UITextView = {
    let view = UITextView()
    view.font = Font.Pretendard(.Regular).of(size: 25)
    view.isEditable = false
    view.isScrollEnabled = true
    view.isSelectable = false
    view.showsVerticalScrollIndicator = false
    view.textContainer.lineFragmentPadding = 0
    view.textContainerInset = .zero
    view.contentInset = .zero
    return view
  }()
  
  public weak var delegate: UITextViewDelegate? {
    didSet {
      textView.delegate = delegate
    }
  }
  
  public var file: ContentFile? {
    didSet {
      guard let file else { return }
      applyConfig(config, file: file)
    }
  }
  
  private let config: TextViewerConfig
  
  init(config: TextViewerConfig) {
    self.config = config
    super.init(frame: .zero)
  }
  
  public override func configureUI() {
    super.configureUI()
    
    addSubview(textView)
    textView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func applyConfig(_ config: TextViewerConfig, file: ContentFile) {
    textView.font = config.font
    textView.textColor = config.textColor
    textView.textAlignment = config.textAlignment
    textView.textContainerInset = .init(top: 0, left: config.padding.left, bottom: config.padding.bottom, right: config.padding.right)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = config.lineHeight
    paragraphStyle.firstLineHeadIndent = config.firstLineHeadIndent
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: config.font,
      .foregroundColor: config.textColor,
      .paragraphStyle: paragraphStyle
    ]
    let text = file.formattedContent
    
    textView.attributedText = NSAttributedString(string: text, attributes: attributes)
  }
}
