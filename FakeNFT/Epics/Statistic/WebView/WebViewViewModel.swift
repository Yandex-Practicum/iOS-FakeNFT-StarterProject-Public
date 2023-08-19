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
    let url = URL(string: "https://practicum.yandex.ru")
    @Published private(set) var progress: Float = 0
    @Published private(set) var isProgressHidden = false

    func checkProgress(_ value: Double) {
        progress = Float(value)
        isProgressHidden = shouldHideProgress(for: value)
    }

    private func shouldHideProgress(for value: Double) -> Bool {
        (value - 0.95) >= 0.0
    }
}
