//
//  FavoritesNft.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 05.09.2023.
//

import UIKit

final class FavoritesNFTViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: FavouritesNftViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            FavoritesNFTCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoritesNFTCollectionViewCell.identifier
        )
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.text = "У Вас еще нет избранных NFT"
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Избранные NFT"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var visibleNFT: [MockNftModel] = []
    // MARK: - Initialiser

    init(viewModel: FavouritesNftViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layouts()
        setupNavBar()
        bind()
        updateView()
    }
    // MARK: - Methods

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.topItem?.title = ""
    }

    private func bind() {
        viewModel.favoritesNftDidChange = { [weak self] in
            self?.updateView()
        }
        viewModel.showErrorAlertDidChange = { [weak self] in
            if let needShowAlert = self?.viewModel.showErrorAlert, needShowAlert {
                self?.showErrorAlert {
                    self?.viewModel.initialisation()
                }
            }
        }
    }

    private func showErrorAlert(action: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Ошибка загрузки данных",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: "Ok",
            style: .default
        ) { _ in action() }

        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    private func updateView() {
        collectionView.reloadData()
        collectionView.isHidden = viewModel.favoritesNft.isEmpty
        placeHolderLabel.isHidden = !viewModel.favoritesNft.isEmpty
    }

    private func layouts() {
        [collectionView, placeHolderLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeHolderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritesNft.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesNFTCollectionViewCell.identifier,
            for: indexPath
        ) as? FavoritesNFTCollectionViewCell else {
            assertionFailure("Не удалось создать ячейку коллекции в FavoritesNFTViewController ")
            return UICollectionViewCell()
        }
        let nft = viewModel.favoritesNft[indexPath.row]
        cell.configureCell(with: nft)
        cell.likeButtonAction = { [weak self] in
            self?.viewModel.likeButtonTapped(indexPath: indexPath)
        }
        return cell
    }
}

extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 168, height: 80)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 20
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
