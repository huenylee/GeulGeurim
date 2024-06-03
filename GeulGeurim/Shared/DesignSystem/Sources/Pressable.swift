//
//  Pressable.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 3.06.2024.
//

import UIKit

public protocol Pressable: Touchable {
  /// Method to transition to press state
  func press()
  
  /// Method to release from press state
  func unpress()
}
