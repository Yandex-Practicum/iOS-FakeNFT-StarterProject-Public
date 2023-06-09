//
//  WebsiteViewModel.swift
//  FakeNFT
//

import Foundation

final class WebsiteViewModel: ViewModelProtocol {

    private let websiteURLString: String

    @Observable
    private var progressValue: Float = 0

    private var websiteURL: URL {
        guard let url = URL(string: websiteURLString) else {
            preconditionFailure("Unable to construct website URL")
        }
        return url
    }

    init(websiteURLString: String) {
        self.websiteURLString = websiteURLString
    }
}

extension WebsiteViewModel: WebsiteViewModelProtocol {

    var progressValueObservable: Observable<Float> { $progressValue }

    var shouldHideProgress: Bool { (1 - progressValue) <= 0.0001 }

    var websiteURLRequest: URLRequest { URLRequest(url: websiteURL) }

    func received(_ newProgressValue: Double) {
        progressValue = Float(newProgressValue)
    }
}
