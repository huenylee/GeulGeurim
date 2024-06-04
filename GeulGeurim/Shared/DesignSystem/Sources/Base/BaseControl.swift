//
//  BaseControl.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.06.2024.
//

import UIKit

public class BaseControl: UIControl {
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
