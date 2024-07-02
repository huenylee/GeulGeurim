//
//  TextFilePageViewerView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 21.06.2024.
//

import UIKit

public struct TextViewerConfig {
  var font: UIFont
  private var _lineSpacing: CGFloat
  var lineHeight: CGFloat {
    get {
      return _lineSpacing
    }
    set {
      _lineSpacing = max(font.pointSize * newValue - font.pointSize, 0)
    }
  }
  var textColor: UIColor
  var textAlignment: NSTextAlignment
  var firstLineHeadIndent: CGFloat
  var bounds: CGSize
  var padding: UIEdgeInsets
  
  init(font: UIFont, lineHeight: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment, firstLineHeadIndent: CGFloat, bounds: CGSize, padding: UIEdgeInsets) {
    self.font = font
    self._lineSpacing = max(font.pointSize * lineHeight - font.pointSize, 0)
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.firstLineHeadIndent = firstLineHeadIndent
    self.bounds = bounds
    self.padding = padding
  }
}

public final class TextFilePageViewerView: BaseController {
  private let label: UILabel = {
    let view = UILabel()
    view.numberOfLines = 0
    return view
  }()
  
  private let content: String
  private let config: TextViewerConfig
  
  init(content: String, config: TextViewerConfig) {
    self.content = content
    self.config = config
    super.init()
    
    label.text = content
    configureLabel()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public override func configureUI() {
    super.configureUI()
    
    configureLabel()
    
    view.addSubview(label)
    label.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.horizontalEdges.equalToSuperview().inset(config.padding)
    }
  }
  
  private func configureLabel() {
    label.font = config.font
    label.textColor = config.textColor
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = config.lineHeight
    paragraphStyle.alignment = config.textAlignment
    paragraphStyle.firstLineHeadIndent = config.firstLineHeadIndent
    let attributedText = NSAttributedString(
      string: content,
      attributes: [.paragraphStyle: paragraphStyle, .font: config.font]
    )
    label.attributedText = attributedText
  }
}
