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
    
    view.backgroundColor = UIColor.white
  }
}
