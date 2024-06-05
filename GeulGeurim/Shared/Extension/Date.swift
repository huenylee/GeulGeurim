//
//  Date.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 5.06.2024.
//

import Foundation

extension Date {
  private static let dateFormatter = DateFormatter()
  private static let shared: Date = Date()
  
  public func toString(pattern: String) -> String {
    let dateFormatter = Self.dateFormatter
    dateFormatter.dateFormat = pattern
    return dateFormatter.string(from: self)
  }
}
