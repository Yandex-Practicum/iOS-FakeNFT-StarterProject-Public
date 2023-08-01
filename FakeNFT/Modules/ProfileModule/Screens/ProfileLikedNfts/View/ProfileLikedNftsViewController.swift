//
//  ProfileLikedNftsViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 20.07.2023.
//

import UIKit
import Combine

final class ProfileLikedNftsViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: ProfileLikedNftsViewModel
    private let dataSource: GenericCollectionViewDataSourceProtocol
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ProfileLikedNftsCollectionCell.self, forCellWithReuseIdentifier: ProfileLikedNftsCollectionCell.defaultReuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: Init
    init(viewModel: ProfileLikedNftsViewModel, dataSource: GenericCollectionViewDataSourceProtocol) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        setupLeftNavBarItem(title: K.Titles.favouriteNfts, action: #selector(cancelTapped))
        createDataSource()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
    
    // MARK: Bind
    private func bind() {
        viewModel.$visibleNfts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] likedNfts in
                self?.updateDataSource(with: likedNfts)
            }
            .store(in: &cancellables)
    }
    
    private func load() {
        viewModel.load()
    }

}

// MARK: - Ext DelegateFlowLayout
extension ProfileLikedNftsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width / GridItemSize.twoInRow.rawValue - 1), height: 80)
    }
}

// MARK: - Ext DataSource
private extension ProfileLikedNftsViewController {
    func createDataSource() {
        dataSource.createDataSource(with: collectionView, from: viewModel.visibleNfts)
    }
    
    func updateDataSource(with nfts: [LikedSingleNfts]) {
        guard nfts.isEmpty else {
            dataSource.updateCollection(with: nfts)
            return
        }
    }
}

// MARK: - Ext @objc
@objc private extension ProfileLikedNftsViewController {
    func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Ext Constraints
private extension ProfileLikedNftsViewController {
    func setupConstraints() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
