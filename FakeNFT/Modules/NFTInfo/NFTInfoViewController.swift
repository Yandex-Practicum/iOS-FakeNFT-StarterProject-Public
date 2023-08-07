//
//  NFTInfoViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import UIKit
import SafariServices

final class NFTInfoViewController: UIViewController {
    private let viewModel: NFTInfoViewModel
    private lazy var container = NFTInfoContainerView(
        imageURL: viewModel.imageURL,
        sectionName: viewModel.sectionName,
        sectionAuthor: viewModel.sectionAuthor,
        sectionDescription: viewModel.sectionDescription) { [weak self] event in
        guard let self else { return }
        switch event {
        case let .toggleFavouriteState(index):
            self.viewModel.toggleNftFavouriteState(index: index)
        case let .selectBin(index):
            self.viewModel.toggleNftSelectedState(index: index)
        case .openWebView:
            self.pushWebView()
        }
    }

    init(viewModel: NFTInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTInfoViewController -> init(coder:) has not been implemented"
        )
    }

    override func loadView() {
        view = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.nfts.bind { [weak self] items in
            self?.container.configure(with: .init(nfts: items))
        }
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(), for: .any, barMetrics: .default
        )

        tabBarController?.tabBar.isHidden = true
    }
    
    func pushWebView() {
        self.navigationController?.pushViewController(
            WebViewFactory.create(url: "https://www.yandex.com"),
            animated: true
        )
    }
}

