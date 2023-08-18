//
//  WebViewScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 13.08.2023.
//

import Foundation

final class WebViewScreenViewPresenter: WebViewScreenViewPresenterProtocol {
    weak private var viewController: WebViewScreenViewControllerProtocol?
    var authorWebSiteURLRequest: URLRequest?
    
    init(viewController: WebViewScreenViewControllerProtocol) {
        self.viewController = viewController
        guard let link = AuthorNetworkService.shared.author?.website.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: link) else { return }
        self.authorWebSiteURLRequest = URLRequest(url: url)
    }
    
    func viewDidUpdateProgressValue(estimatedProgress: Float) {
        viewController?.updateProgressView(estimatedProgress: estimatedProgress)
        if estimatedProgress == 1 {
            viewController?.removeProgressView()
        }
    }
}
