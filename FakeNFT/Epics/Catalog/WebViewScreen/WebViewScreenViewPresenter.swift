//
//  WebViewScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 13.08.2023.
//

import Foundation

final class WebViewScreenViewPresenter: WebViewScreenViewPresenterProtocol {
    weak var viewController: WebViewScreenViewControllerProtocol?
    var authorWebSiteLink: String
    
    init(authorWebSiteLink: String) {
        self.authorWebSiteLink = authorWebSiteLink
    }
    
    func didUpdateProgressValue(estimatedProgress: Float) {
        viewController?.updateProgressView(estimatedProgress: estimatedProgress)
        if estimatedProgress == 1 {
            viewController?.removeProgressView()
        }
    }
}
