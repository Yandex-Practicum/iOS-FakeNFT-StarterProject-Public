//
//  WebViewScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 13.08.2023.
//

import Foundation

final class WebViewScreenViewPresenter: WebViewScreenViewPresenterProtocol {
    var viewController: WebViewScreenViewControllerProtocol?
    var authorWebSiteLink: String?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    init() {
        estimatedProgressObservation = viewController?.webView.observe(\.estimatedProgress, options: [], changeHandler: { [weak self] _, _ in
            guard let self = self, let viewController = self.viewController else { return }
            self.didUpdateProgressValue(estimatedProgress: Float(viewController.webView.estimatedProgress))
        })
    }
    
    func didUpdateProgressValue(estimatedProgress: Float) {
        viewController?.updateProgressView(estimatedProgress: estimatedProgress)
        if estimatedProgress == 1 {
            viewController?.removeProgressView()
        }
    }
}
