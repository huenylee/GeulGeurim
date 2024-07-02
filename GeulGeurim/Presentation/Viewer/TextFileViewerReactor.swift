//
//  TextFileViewerReactor.swift
//  GeulGeurim
//
//  Created by HUNHEE LEE on 27.06.2024.
//

import Foundation
import ReactorKit
import RxSwift

public final class TextFileViewerReactor: Reactor {
  public enum Action {
    case loadViewer(ContentFile)
    case changeMode(TextFileViewerMode)
  }
  
  public enum Mutation {
    case setFile(ContentFile)
    case setMode(TextFileViewerMode)
  }
  
  public struct State {
    var file: ContentFile?
    var mode: TextFileViewerMode = .scrollMode
  }
  
  public let initialState: State = .init()
}

extension TextFileViewerReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .changeMode(let mode):
      return .just(.setMode(mode))
    case .loadViewer(let file):
      return .just(.setFile(file))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setFile(let contentFile):
      newState.file = contentFile
    case .setMode(let textFileViewerMode):
      newState.mode = textFileViewerMode
    }
    return newState
  }
}

public enum TextFileViewerMode {
  case pageMode
  case scrollMode
}
