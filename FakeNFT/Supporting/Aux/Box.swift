//
//  Box.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//
// https://www.kodeco.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc

import Foundation

final class Box<T> {
  typealias Listener = (T) -> Void
    
  var listener: Listener?
  
    var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }

  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
    
}
