//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 03.08.2023.
//

import UIKit

final class CollectionScreenViewController: UIViewController, CollectionScreenViewControllerProtocol {
    private var presenter: CollectionScreenViewPresenterProtocol?
    private let backButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var calculateMainContentHeight: CGFloat {
        guard let presenter = presenter else { return CGFloat() }
        let imageSize: CGFloat = 310
        let nameHeight: CGFloat = calculateLabelHeight(text: presenter.takeCollectionName, width: view.frame.width - 32, font: .headline3)
        let authorHeight: CGFloat = calculateLabelHeight(text: NSLocalizedString("catalog.author", comment: "Статическая надпись, представляющая автора коллекции nft"), width: view.frame.width - 32, font: .caption2)
        let descriptionHeight: CGFloat = calculateTextViewHeight(text: presenter.takeCollectionDescription, width: view.frame.width-32, font: .caption2)
        let constraints: CGFloat = 16 + 13 + 5
        return imageSize + nameHeight + authorHeight + descriptionHeight + constraints
    }
    
    init(catalogDataModel: CatalogDataModel) {
        super.init(nibName: nil, bundle: nil)
        presenter = CollectionScreenViewPresenter(viewController: self, catalogDataModel: catalogDataModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureCollection()
        configureBackButton()
        
        makeFetchRequest()
    }
    
    func updateCollection(oldCount: Int, newCount: Int) {
        collectionView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 1)
            }
            collectionView.insertItems(at: indexPaths)
        } completion: { _ in
        }
    }
    
    func updateAuthor() {
        guard let name = AuthorNetworkService.shared.author?.name else { return }
        (collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CollectionScreenMainContentCell)?.setAuthorDynamicPartLabel(author: name)
        viewReadinessCheck()
    }
    
    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func viewReadinessCheck() {
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CollectionScreenMainContentCell else { return }
        if !cell.authorDynamicPartLabelIsEmpty
            && !cell.collectionImageIsEmpty
            && collectionView.numberOfItems(inSection: 1) == presenter?.takeInitialNftCount {
            removeHud()
        }
    }
    
    func authorLabelTap() {
        guard let presenter = presenter else { return }
        present(presenter.createWebViewScreen, animated: true)
    }
    
    private func makeFetchRequest() {
        UIBlockingProgressHUD.show()
        presenter?.makeFetchRequest()
    }
    
    private func configureBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack), for: .normal)
        backButton.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureCollection() {
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CollectionScreenMainContentCell.self)
        collectionView.register(CollectionScreenNftCell.self)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureMainContentCell(cell: CollectionScreenMainContentCell) {
        guard let presenter = presenter else { return }
        cell.viewController = self
        cell.setCollectionImage(link: presenter.takeCollectionCover)
        cell.setCollectionNameLabel(name: presenter.takeCollectionName)
        cell.setDescriptionTextView(description: presenter.takeCollectionDescription)
    }
    
    private func configureNftCell(cell: CollectionScreenNftCell, index: Int) {
        guard let presenter = presenter else { return }
        let nft = presenter.takeNftFromNfts(index: index)
        cell.nft = nft
        if BasketService.shared.basket.contains(where: )({ $0.id == nft.id }) {
            cell.setNotEmptyBasketImage()
        }
        if LikeService.shared.likes.contains(nft.id) {
            cell.setButtonLikeImage(image: .liked)
        }
        cell.setNftImage(link: nft.images.first ?? "")
        cell.setRating(rate: nft.rating)
        cell.setNameLabel(name: nft.name)
        cell.setCostLabel(cost: nft.price)
    }
    
    private func calculateTextViewHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let textView = UITextView()
        textView.text = text
        textView.font = font
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        textView.frame.size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
    }
    
    private func calculateLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let textView = UILabel()
        textView.text = text
        textView.font = font
        textView.frame.size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
    }
    
    @objc func buttonBackTap() {
        dismiss(animated: true)
    }
}

extension CollectionScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width, height: calculateMainContentHeight)
        case 1:
            let width = (collectionView.frame.width - 32 - 18) / 3    // MARK: из длинны экрана вычитаем констрейнты (16+16=32) и получаем длину коллекции, из неё вычитаем отступы между клетками (9x2=18)
            let height = width * 1.593
            return CGSize(width: width, height: height)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 1:
            return 9
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 1:
            return 28
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: -view.safeAreaInsets.top, left: 0, bottom: 24, right: 0)
        case 1:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension CollectionScreenViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return presenter?.actualNftsCount ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let cell: CollectionScreenNftCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            configureNftCell(cell: cell, index: indexPath.row)
            return cell
        case 0:
            let cell: CollectionScreenMainContentCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            configureMainContentCell(cell: cell)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
