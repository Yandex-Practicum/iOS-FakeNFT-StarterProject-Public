//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 03.08.2023.
//

import UIKit

final class CollectionScreenViewController: UIViewController, CollectionScreenViewControllerProtocol {
    var currentNumberOfNft: Int {
        collectionView.numberOfItems(inSection: 1)
    }
    
    private var presenter: CollectionScreenViewPresenterProtocol
    private let backButton = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var mainContentHeight: CGFloat {
        let imageSize: CGFloat = 310
        let nameHeight: CGFloat = calculateLabelHeight(text: presenter.collectionName, width: view.frame.width - 32, font: .headline3)
        let authorHeight: CGFloat = calculateLabelHeight(text: NSLocalizedString("catalog.author", comment: "Статическая надпись, представляющая автора коллекции nft"), width: view.frame.width - 32, font: .caption2)
        let descriptionHeight: CGFloat = calculateTextViewHeight(text: presenter.collectionDescription, width: view.frame.width - 32, font: .caption2)
        let constraints: CGFloat = 16 + 13 + 5
        return imageSize + nameHeight + authorHeight + descriptionHeight + constraints
    }
    
    init(presenter: CollectionScreenViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureCollection()
        configureBackButton()
        
        presenter.viewDidLoad()
    }
    
    func updateCollection(oldCount: Int, newCount: Int) {
        collectionView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 1)
            }
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    func updateAuthor() {
        guard let name = presenter.authorName else { return }
        (collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CollectionScreenMainContentCell)?.setAuthorDynamicPartLabel(author: name)
        viewUpdatedUI()
    }
    
    func showHud() {
        UIBlockingProgressHUD.show()
    }
    
    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func viewUpdatedUI() {
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CollectionScreenMainContentCell else { return }
        presenter.viewUpdatedUI(in: cell)
    }
    
    func authorLabelTap() {
        presenter.didTapAuthorLabel()
    }
    
    func show(_ webView: WebViewScreenViewController) {
        present(webView, animated: true)
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
        cell.viewController = self
        cell.setCollectionImage(link: presenter.collectionCover)
        cell.setCollectionNameLabel(name: presenter.collectionName)
        cell.setDescriptionTextView(description: presenter.collectionDescription)
    }
    
    private func configureNftCell(cell: CollectionScreenNftCell, index: Int) {
        let nft = presenter.viewStartedCellConfiguration(at: index)
        let cellPresenter = CollectionScreenNftCellPresenter(nft: nft)
        cell.presenter = cellPresenter
        presenter.viewWillUpdateBasket(in: cell, at: index)
        presenter.viewWillUpdateLike(in: cell, at: index)
        cell.setNftImage(link: presenter.viewWillSetImage(with: (nft.images.first ?? "")))
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
        let label = UILabel()
        label.text = text
        label.font = font
        label.frame.size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let newSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
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
            return CGSize(width: view.frame.width, height: mainContentHeight)
        case 1:
            let width = (collectionView.frame.width - 32) / 3 - 9  // MARK: из длинны экрана вычитаем констрейнты (16+16=32) и получаем длину коллекции, делим её на 3, так как по 3 ячейки, а также вычитаем расстояние между ячейками (9)
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
            return presenter.actualNftsCount
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
