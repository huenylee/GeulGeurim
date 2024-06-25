//
//  TextFilePageViewerController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 20.06.2024.
//

import UIKit

public final class TextFilePageViewerController: UIPageViewController, UIPageViewControllerDataSource {
  private var pages = [String]()
  public let config: TextViewerConfig
  public var pageCount: Int {
    return pages.count
  }
  
  public var content: String? {
    didSet {
      guard let content else { return }
      pages = paginateTextForUILabel(content, config: config)
      setViewControllers([viewControllerForPage(at: 0)], direction: .forward, animated: false, completion: nil)
    }
  }
  
  init(config: TextViewerConfig) {
    self.config = config
    super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
  }
  
  private func viewControllerForPage(at index: Int) -> UIViewController {
    let page = TextFilePageViewerView(content: pages[index], config: config)
    return page
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: (viewController.view.subviews.first as! UILabel).text!) else {
      return nil
    }
    return index > 0 ? viewControllerForPage(at: index - 1) : nil
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = pages.firstIndex(of: (viewController.view.subviews.first as! UILabel).text!) else {
      return nil
    }
    return index < pages.count - 1 ? viewControllerForPage(at: index + 1) : nil
  }
  
  private func paginateTextForUILabel(_ text: String, config: TextViewerConfig) -> [String] {
    var pages = [String]()
    
    let font = config.font
    let lineSpacing = config.lineHeight
    let textAlignment = config.textAlignment
    let bounds = config.bounds
    let padding = config.padding
    let safeAreaInsets = safeAreaTopInset()
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.alignment = textAlignment
    paragraphStyle.firstLineHeadIndent = config.firstLineHeadIndent
    
    let attributedText = NSAttributedString(string: text, attributes: [
      .font: font,
      .paragraphStyle: paragraphStyle
    ])
    
    let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
    
    let contentWidth = bounds.width - padding.left - padding.right
    let contentHeight = bounds.height - padding.top - padding.bottom - safeAreaInsets.top
    
    var startIndex = 0
    let textLength = attributedText.length
    
    let framePath = CGPath(rect: CGRect(origin: .zero, size: CGSize(width: contentWidth, height: contentHeight)), transform: nil)
    
    while startIndex < textLength {
      let range = CFRangeMake(startIndex, textLength - startIndex)
      
      let frame = CTFramesetterCreateFrame(framesetter, range, framePath, nil)
      let frameRange = CTFrameGetVisibleStringRange(frame)
      
      let pageText = (text as NSString).substring(with: NSRange(location: Int(frameRange.location), length: Int(frameRange.length)))
      pages.append(pageText)
      
      startIndex += frameRange.length
    }
    
    return pages
  }
}

func safeAreaTopInset() -> (top: CGFloat, bottom: CGFloat) {
  let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
  let topPadding = scene?.windows.first?.safeAreaInsets.top ?? .zero
  let bottomPadding = scene?.windows.first?.safeAreaInsets.bottom ?? .zero
  return (topPadding, bottomPadding)
}
