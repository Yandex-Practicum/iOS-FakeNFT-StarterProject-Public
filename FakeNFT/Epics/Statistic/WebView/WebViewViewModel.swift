//
//  WebViewViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 19.08.2023.
//

import Foundation
import Combine

protocol WebViewModel {
    var url: URL? { get }
    func checkProgress(_ value: Double)
}

final class WebViewModelImpl: WebViewModel {
    // MARK: - Public Properties
    let url: URL?

    @Published private(set) var progress: Float = 0
    @Published private(set) var isProgressHidden = false

    // MARK: - Init
    init(url: URL?) {
        self.url = url
    }

    // MARK: - Public Methods
    func checkProgress(_ value: Double) {
        progress = Float(value)
        isProgressHidden = shouldHideProgress(for: value)
    }

    // MARK: - Private Methods
    private func shouldHideProgress(for value: Double) -> Bool {
        (value - 0.95) >= 0.0
    }
}
