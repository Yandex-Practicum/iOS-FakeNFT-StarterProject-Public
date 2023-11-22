//
//  AuthorWebViewViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 22.11.2023.
//

import Foundation
import Combine

final class AuthorWebViewViewModel: AuthorWebViewViewModelProtocol {
    @Published var progressValue: Float = 0
    @Published var shouldHideProgress: Bool = false
    var progressPublisher: Published<Float>.Publisher { $progressValue }
    var progressStatePublisher: Published<Bool>.Publisher { $shouldHideProgress }

    init() {
    }

    func viewDidLoad() {
        didUpdateProgressValue(0)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        progressValue = Float(newValue)

        shouldHideProgress = shouldHideProgress(for: Float(newValue))
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
