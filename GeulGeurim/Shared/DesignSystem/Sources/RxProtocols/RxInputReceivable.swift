//
//  RxInputReceivable.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 4.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

public protocol RxInputReceivable: AnyObject {
  associatedtype InputEventType
  var inputEventRelay: PublishRelay<InputEventType> { get }
}
