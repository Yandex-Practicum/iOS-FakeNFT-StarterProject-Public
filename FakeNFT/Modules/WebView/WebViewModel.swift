//
//  WebViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import Foundation

protocol WebViewModel {
    var url: String { get }
}

final class WebViewModelImpl: WebViewModel {
    private(set) var url: String

    init(url: String) {
        self.url = url
    }
}
