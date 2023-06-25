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
        container.configure(configuration: .loading)
        viewModel.getItems { [weak self] items in
            guard let self else { return }
            DispatchQueue.main.async {
                self.container.configure(configuration: .loaded(items))
            }
        }
    }

    private func configureNavigationController() {
        navigationController?.navigationBar.tintColor = .appBlack
        navigationController?.navigationBar.backgroundColor = .appWhite
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.appFont(.bold, withSize: 17),
            .foregroundColor: UIColor.appBlack
        ]
    }
}
