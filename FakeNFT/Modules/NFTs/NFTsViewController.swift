//
//  NFTsViewController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

final class NFTsViewController: UIViewController {
    private let viewModel: NFTsViewModel

    private lazy var sortButton: UIBarButtonItem = {
        let image = UIImage.Icons.sort
        let button = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(sortClickHandler)
        )
        return button
    }()

    private lazy var container = NFTsContainerView { [weak self] event in
        switch event {
        case .reload:
            self?.viewModel.reload()
        case .cellSelected(let index):
            self?.viewModel.cellSelected(index: index)
        }
    }

    init(viewModel: NFTsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTsViewController -> init(coder:) has not been impl"
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }

    override func loadView() {
        view = container
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareViewToBeAppeared()
    }

    private func prepareViewToBeAppeared() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.backgroundColor = .appWhite
        tabBarController?.tabBar.isHidden = false
    }

    private func configureNavigationController() {
        navigationItem.rightBarButtonItem = sortButton

        navigationController?.navigationBar.tintColor = .appBlack
        navigationController?.navigationBar.backgroundColor = .appWhite
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(style: .bold, size: 17),
            .foregroundColor: UIColor.appBlack
        ]
    }

    @objc private func sortClickHandler() {
        present(
            NFTSortingFactory.create { [weak self] output in
                self?.viewModel.sortItems(with: output)
            },
            animated: true
        )
    }

    private func handleViewModelStateChangeForUi(
        isToBeHidden: Bool
    ) {
        tabBarController?.tabBar.isHidden = isToBeHidden
    }

    private func configureModelBindings() {
        viewModel.state.bind { [weak self] state in
            switch state {
            case .loading:
                Executors.asyncMain {
                    self?.container.configure(for: .loading)
                    self?.handleViewModelStateChangeForUi(
                        isToBeHidden: false
                    )
                }
            case let .loaded(items):
                Executors.asyncMain {
                    self?.container.configure(
                        for: .loaded(items)
                    )
                    self?.handleViewModelStateChangeForUi(
                        isToBeHidden: false
                    )
                }
            case .error:
                Executors.asyncMain {
                    self?.container.configure(for: .error)
                    self?.handleViewModelStateChangeForUi(
                        isToBeHidden: true
                    )
                }
            }
        }

        viewModel.visibleNft.bind { [weak self] cellInfo in
            guard let self, let cellInfo else { return }

            self.showNFTInfoScreen(info: cellInfo)
        }
    }

    private func configureController() {
        view.backgroundColor = .appWhite
        configureNavigationController()
        viewModel.viewDidLoad()
        configureModelBindings()
    }

    private func showNFTInfoScreen(info: NFTInfo) {
        navigationController?.pushViewController(
            NFTInfoFactory.create(info: info),
            animated: true
        )
    }
}
