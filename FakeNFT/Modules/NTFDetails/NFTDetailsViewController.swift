//
//  NFTDetailsViewController.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit
import SafariServices

final class NFTDetailsViewController: UIViewController {

    private let viewModel: NFTDetailsViewModel
    private lazy var container = NFTDetailsContainerView(
        imageURL: viewModel.imageURL,
        sectionName: viewModel.sectionName,
        sectionAuthor: viewModel.sectionAuthor,
        sectionDescription: viewModel.sectionDescription) { [weak self] event in
        guard let self else { return }
        switch event {
        case let .selectFavourite(index):
            self.viewModel.selectFavourite(index: index)
        case let .selectBasket(index):
            self.viewModel.selectedNft(index: index)
        case .openWebView:
            self.pushWebView()
        }
    }

    init(viewModel: NFTDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.nfts.bind { [weak self] items in
            self?.container.configure(.init(nfts: items))
        }
        setupAppearance()
    }

    private func setupAppearance() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear

        tabBarController?.tabBar.isHidden = true

        navigationController?.navigationBar.topItem?.title = " "

    }
}

// MARK: = Navigation
private extension NFTDetailsViewController {
    func pushWebView() {
        let url = "https://www.yandex.com"
        let webView = WebViewFactory.create(dependency: .init(url: url))
        self.navigationController?.pushViewController(webView, animated: true)
    }
}
