//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import UIKit
import SnapKit

final class NFTCollectionViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.contentInset.top = 20
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .ypWhite
        view.delegate = self
        view.refreshControl = refreshControl
        view.register(NFTCell.self)
        return view
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NFT> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: item)
            return cell
        }
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .ypBlack
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let errorView = ErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        createTabTabItem()
        updateSnapshot(with: [
            .init(imageURL: nil, title: "Apple", rating: 1, price: 1, isLiked: true, isInCart: false),
            .init(imageURL: nil, title: "Banana", rating: 2, price: 2, isLiked: false, isInCart: true),
            .init(imageURL: nil, title: "Orange", rating: 3, price: 3, isLiked: true, isInCart: false),
            .init(imageURL: nil, title: "Qiwi", rating: 4, price: 4, isLiked: true, isInCart: false),
            .init(imageURL: nil, title: "Cucamber", rating: 5, price: 5, isLiked: true, isInCart: false),
            .init(imageURL: nil, title: "Potato", rating: 6, price: 6, isLiked: true, isInCart: false)
        ])
    }

    // MARK: - @objc methods
    @objc private func filterTap() { }

    @objc private func pullToRefresh() { }

    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension NFTCollectionViewController: UICollectionViewDelegate { }

// MARK: - Data
private extension NFTCollectionViewController {
    func updateSnapshot(with data: [NFT]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NFT>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UI
private extension NFTCollectionViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            self.createLayoutSection()
        }

        return layout
    }

    func createLayoutSection() -> NSCollectionLayoutSection {
        // Item
        let itemInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 8, trailing: 5)
        let item = NSCollectionLayoutItem.create(
            withWidth: .fractionalWidth(1/3),
            height: .fractionalHeight(1),
            insets: itemInsets
        )

        // Group
        let group = NSCollectionLayoutGroup.create(
            horizontalGroupWithWidth: .fractionalWidth(1.0),
            height: .absolute(200),
            items: [item]
        )

        // Section
        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func createTabTabItem() {
        let image = UIImage(systemName: "chevron.backward")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.ypBlack)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(backButtonTap)
        )
    }

    func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(spinner)
        view.addSubview(errorView)
        view.backgroundColor = .ypWhite
    }

    func addConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().inset(11)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(20)
        }
    }
}
