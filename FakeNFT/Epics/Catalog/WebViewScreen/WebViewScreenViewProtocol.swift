//
//  WebViewScreenViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 13.08.2023.
//

import WebKit

protocol WebViewScreenViewControllerProtocol: AnyObject {
    var webView: WKWebView { get }
    func updateProgressView(estimatedProgress: Float)
    func removeProgressView()
}

protocol WebViewScreenViewPresenterProtocol {
    var authorWebSiteLink: String? { get set }
    func didUpdateProgressValue(estimatedProgress: Float)
}
