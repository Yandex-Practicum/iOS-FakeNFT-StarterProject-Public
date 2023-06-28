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
        self.viewModel.cellSelected(indexPath) { [weak self] details in
            guard let self else { return }
            self.showNFTDetailsScreen(details)
        }
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
        configureNavigationController()
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
        let alertController = UIAlertController(title: Localized.sortTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Localized.byTitle, style: .default) { [weak self] _ in
            guard let self else { return }
            self.viewModel.sortItems(by: .name) { _ in
                self.viewModel.sortItems(by: .name) { self.container.configure(configuration: .loaded($0))}
            }
        })
        alertController.addAction(UIAlertAction(title: Localized.byCount, style: .default) { [weak self] _ in
            guard let self else { return }
            self.viewModel.sortItems(by: .amount) { _ in
                self.viewModel.sortItems(by: .amount) { self.container.configure(configuration: .loaded($0))}
            }
        })
        alertController.addAction(UIAlertAction(title: Localized.close, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: Navigation
private extension NFTListViewController {
    func showNFTDetailsScreen(_ details: NFTDetails) {
        let viewController = NFTDetailsFactory.create(details)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
