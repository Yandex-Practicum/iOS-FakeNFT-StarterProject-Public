//
//  WebViewViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

protocol WebViewViewModel {
    var url: String { get }
}

final class WebViewViewModelImpl: WebViewViewModel {
    private(set) var url: String

    init(url: String) {
        self.url = url
    }
}
