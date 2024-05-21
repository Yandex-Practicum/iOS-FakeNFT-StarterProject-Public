//
//  UserNFTCollectionView.swift
//  FakeNFT
//
//  Created by Сергей on 25.04.2024.
//

import UIKit
import ProgressHUD

protocol UserNFTCollectionViewProtocol: AnyObject {
    var presenter: UserNFTPresenterProtocol { get set }
    func reload()
    func updateEmptyView()
}

final class UserNFTCollectionView: UIViewController & UserNFTCollectionViewProtocol {

    var presenter: UserNFTPresenterProtocol

    init(nft: [String]) {
        self.presenter = UserNFTPresenter()
        self.presenter.nftsIDs = nft
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var nftCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(UserNFTCollectionCell.self, forCellWithReuseIdentifier: UserNFTCollectionCell.identifier)

        return collection
    }()

    private lazy var emptyCollectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "У пользователя еще нет NFT"
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        navigationController?.delegate = self
        navigationItem.title = "Коллекция NFT"
        view.backgroundColor = .systemBackground
        setViews()
        setConstraints()
    }

    private func setViews() {
        [nftCollection, emptyCollectionLabel, activityIndicator].forEach {
            view.addSubview($0)
        }
        activityIndicator.center = view.center
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            nftCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyCollectionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCollectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func reload() {
        nftCollection.reloadData()
    }

    func updateEmptyView() {
        if presenter.visibleNFT.isEmpty {
            emptyCollectionLabel.isHidden = false
        } else {
            emptyCollectionLabel.isHidden = true
        }
    }

    @objc func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension UserNFTCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.visibleNFT.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserNFTCollectionCell.identifier,
                                                            for: indexPath) as? UserNFTCollectionCell

        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        let nft = presenter.visibleNFT[indexPath.row]
        if let cart = self.presenter.cart,
           let profile = self.presenter.profile {
            cell.set(nft: nft, cart: cart, profile: profile)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension UserNFTCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 52) / 3, height: 192)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
    }
}

extension UserNFTCollectionView: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(customBackAction))
            navigationItem.leftBarButtonItem = backButton

        }
    }
}

extension UserNFTCollectionView: UserNFTCellDelegate {

    func addToCartButtonClicked(_ cell: UserNFTCollectionCell, nft: NFTModel) {
        presenter.changeCart(nft: nft) { result in
            switch result {
            case .success(let isAdded):
                cell.setIsAdded(isAdded: isAdded)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func addFavouriteButtonClicked(_ cell: UserNFTCollectionCell, nft: NFTModel) {
        presenter.changeLike(nft: nft) { result in
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked: isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
