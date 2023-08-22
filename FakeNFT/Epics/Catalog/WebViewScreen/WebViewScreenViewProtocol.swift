//
//  WebViewScreenViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 13.08.2023.
//

import WebKit

protocol WebViewScreenViewControllerProtocol: AnyObject {
    func updateProgressView(estimatedProgress: Float)
    func removeProgressView()
}

protocol WebViewScreenViewPresenterProtocol {
    var authorWebSiteURLRequest: URLRequest? { get }
    func viewControllerInitialized(viewController: WebViewScreenViewControllerProtocol)
    func viewDidUpdateProgressValue(estimatedProgress: Float)
}
