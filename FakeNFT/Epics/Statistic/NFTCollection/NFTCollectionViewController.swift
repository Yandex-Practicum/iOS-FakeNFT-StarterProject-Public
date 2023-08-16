//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import UIKit
import SnapKit
import Combine

final class NFTCollectionViewController: NiblessViewController {
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.contentInset.top = 20
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .ypWhite
        view.delegate = self
        view.isHidden = true
        view.alpha = 0
        view.refreshControl = refreshControl
        view.register(NFTCell.self)
        return view
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NFTCellViewModel> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, viewModel in
            let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: viewModel)
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

    private let viewModel: NFTCollectionViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: NFTCollectionViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        createTabTabItem()
        setTitle()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: - @objc methods
    @objc private func pullToRefresh() {        
        viewModel.pullToRefresh()
    }

    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension NFTCollectionViewController: UICollectionViewDelegate { }

// MARK: - Data
private extension NFTCollectionViewController {
    func bind(to viewModel: NFTCollectionViewModel) {
        viewModel.nftViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nfts in
                self?.configureUI(with: nfts)
            }
            .store(in: &cancellables)

        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.errorView.hideErrorView()
                isLoading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.hideCollectionView()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.errorView.showErrorView()
            }
            .store(in: &cancellables)
    }

    func updateSnapshot(with data: [NFTCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NFTCellViewModel>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func configureUI(with nfts: [NFTCellViewModel]) {
        if !nfts.isEmpty {
            self.showCollectionView()
            self.errorView.hideErrorView()

            if viewModel.isPulledToRefresh {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateSnapshot(with: nfts)
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            else {
                self.updateSnapshot(with: nfts)
                self.collectionView.refreshControl?.endRefreshing()
            }

        } else {
            // TODO: - Добавить заглушку если массив пустой
        }
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

    func setTitle() {
        title = "Коллекция NFT"
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

    func hideCollectionView() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.isHidden = true
            self.collectionView.alpha = 0
        }
    }

    func showCollectionView() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.isHidden = false
            self.collectionView.alpha = 1
        }
    }
}
