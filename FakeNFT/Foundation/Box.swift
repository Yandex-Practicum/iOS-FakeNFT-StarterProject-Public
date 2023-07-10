//
//  Box.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

// https://www.kodeco.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc
final class Box<T> {
  // 1
  typealias Listener = (T) -> Void
  var listener: Listener?
  // 2
  var value: T {
    didSet {
      listener?(value)
    }
  }
  // 3
  init(_ value: T) {
    self.value = value
  }
  // 4
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
