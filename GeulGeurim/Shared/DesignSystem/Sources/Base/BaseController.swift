//
//  BaseController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 1.06.2024.
//

import UIKit

open class BaseController: UIViewController {
  
  open override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    
    view.backgroundColor = UIColor.basicWhite
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  open func configureUI() {
    
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
