//
//  WebViewREquestHandler.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 23.06.2023.
//

import Foundation

protocol RequestHandling {
    func createUserLicenseRequest() -> URLRequest?
}

struct WebViewRequestHandler { }

extension WebViewRequestHandler: RequestHandling {
    func createUserLicenseRequest() -> URLRequest? {
        guard let url = makeUrl(from: K.Links.userLicenseLink) else { return nil }
        return URLRequest(url: url)
    }
}

private extension WebViewRequestHandler {
    func makeUrl(from string: String) -> URL? {
        return URL(string: string)
    }
}
