//
//  NFTListViewController.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

final class NFTListViewController: UIViewController {

    private let viewModel: NFTListViewModel
    private lazy var container = NFTListContainerView { [weak self] indexPath in
        guard let self else { return }
        self.viewModel.cellSelected(indexPath)
    }

    init(viewModel: NFTListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = container
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        configureNavigationController()
        viewModel.viewDidLoad()
        viewModel.state.bind { [weak self] state in
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    self?.container.configure(configuration: .loading)
                    self?.navigationController?.navigationBar.isHidden = true
                }
            case let .loaded(items):
                DispatchQueue.main.async {
                    self?.container.configure(configuration: .loaded(items))
                    self?.navigationController?.navigationBar.isHidden = false
                }
            }
        }

        viewModel.nftToShow.bind { [weak self] cellDetails in
            guard let self else { return }
            if let cellDetails {
                self.showNFTDetailsScreen(cellDetails)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
    }

    private func setupAppearance() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.backgroundColor = .appWhite

        tabBarController?.tabBar.isHidden = false
    }

    private func configureNavigationController() {
        navigationController?.navigationBar.tintColor = .appBlack
        navigationController?.navigationBar.backgroundColor = .appWhite
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.appFont(.bold, withSize: 17),
            .foregroundColor: UIColor.appBlack
        ]
        let barItem = UIBarButtonItem(image: UIImage(named: Constants.IconNames.sort),
                                      style: .done,
                                      target: self,
                                      action: #selector(sortTapped))

        navigationController?.navigationBar.topItem?.rightBarButtonItem = barItem
    }

    @objc private func sortTapped() {
        let alertViewController = NFTSortingFactory.create { [weak self] output in
            guard let self else { return }
            self.viewModel.sortItems(by: output)
        }
        present(alertViewController, animated: true)
    }
}

// MARK: Navigation
private extension NFTListViewController {
    func showNFTDetailsScreen(_ details: NFTDetails) {
        let viewController = NFTDetailsFactory.create(details)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
