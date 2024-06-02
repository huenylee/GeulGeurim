//
//  BaseView.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 1.06.2024.
//

import UIKit

open class BaseView: UIView {
  public override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func configureUI() {
    
  }
}
