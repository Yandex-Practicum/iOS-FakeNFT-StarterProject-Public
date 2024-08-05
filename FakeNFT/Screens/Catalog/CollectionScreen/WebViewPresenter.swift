//
//  WebViewPresenter.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation
import Combine

protocol WebViewPresenterProtocol: AnyObject {
  var progressValue: Float { get set }
  var progressPublisher: Published<Float>.Publisher { get }
  var shouldHideProgress: Bool { get set }
  var progressStatePublisher: Published<Bool>.Publisher { get }

  func viewDidLoad()
  func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter: ObservableObject, WebViewPresenterProtocol {

  @Published var progressValue: Float = 0
  @Published var shouldHideProgress: Bool = false

  var progressPublisher: Published<Float>.Publisher { $progressValue }
  var progressStatePublisher: Published<Bool>.Publisher { $shouldHideProgress }

  func viewDidLoad() {
    didUpdateProgressValue(0)
  }

  func didUpdateProgressValue(_ newValue: Double) {
    self.progressValue = Float(newValue)

    shouldHideProgress = shouldHideProgress(for: Float(newValue))
  }

  private func shouldHideProgress(for value: Float) -> Bool {
    abs(value - 1.0) <= 0.0001
  }
}
