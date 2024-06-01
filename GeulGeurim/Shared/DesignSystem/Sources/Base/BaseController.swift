//
//  BaseController.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 1.06.2024.
//

import UIKit

public final class BaseController: UIViewController {
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    
    view.backgroundColor = UIColor.white
  }
}
