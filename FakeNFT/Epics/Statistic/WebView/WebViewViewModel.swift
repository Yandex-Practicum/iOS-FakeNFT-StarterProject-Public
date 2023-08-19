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
    var progress: CurrentValueSubject<Float, Never> { get }
    var isProgressHidden: CurrentValueSubject<Bool, Never> { get }

    func checkProgress(_ value: Double)
}

final class WebViewModelImpl: WebViewModel {
    let url = URL(string: "https://practicum.yandex.ru")
    let progress: CurrentValueSubject<Float, Never> = .init(0)
    let isProgressHidden: CurrentValueSubject<Bool, Never> = .init(false)

    func checkProgress(_ value: Double) {
        progress.send(Float(value))
        isProgressHidden.send(shouldHideProgress(for: value))
    }

    private func shouldHideProgress(for value: Double) -> Bool {
        (value - 0.95) >= 0.0
    }
}
