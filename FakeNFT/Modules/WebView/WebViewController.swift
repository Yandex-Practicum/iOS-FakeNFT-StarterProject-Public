//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import Foundation
import WebKit

final class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let viewModel: WebViewModel
    
    override func loadView() {
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
        
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(
            "WebViewController -> init(coder:) has not been implemented"
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishConfiguration()
    }
    
    private func finishConfiguration() {
        navigationController?.navigationBar.topItem?.title = " "
        guard let url = URL(string: viewModel.url) else {
            return
        }
        
        webView.load(
            URLRequest(
                url: url
            )
        )
        webView.allowsBackForwardNavigationGestures = true
    }
}
