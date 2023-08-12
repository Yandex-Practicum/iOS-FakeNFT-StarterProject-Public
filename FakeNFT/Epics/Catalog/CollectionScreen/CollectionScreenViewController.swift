//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 03.08.2023.
//

import UIKit
import Kingfisher

final class CollectionScreenViewController: UIViewController, CollectionScreenViewControllerProtocol {
    var presenter: CollectionScreenViewPresenterProtocol?
    private let scrollView = UIScrollView()
    private let backButton = UIButton()
    private let collectionImage = UIImageView()
    private let collectionNameLabel = UILabel()
    private let authorStaticPartLabel = UILabel()
    private let authorDynamicPartLabel = UILabel()
    private let descriptionLabel = UITextView()
    private let nftsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureScrollView()
        configureCollectionImage()
        configureBackButton()
        configureCollectionNameLabel()
        configureAuthorStaticPartLabel()
        configureAuthorDynamicPartLabel()
        configureDescriptionLabel()
        configureNftsCollection()
        
        makeFetchRequest()
    }
    
    private func makeFetchRequest() {
        UIBlockingProgressHUD.show()
        presenter?.makeFetchRequest()
    }
    
    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateAuthor() {
        authorDynamicPartLabel.text = AuthorNetworkService.shared.author?.name
        viewReadinessCheck()
    }
    
    func updateCollection(oldCount: Int, newCount: Int) {
        nftsCollectionView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            nftsCollectionView.insertItems(at: indexPaths)
        } completion: { _ in }
    }
    
    func viewReadinessCheck() {
        if !(authorDynamicPartLabel.text?.isEmpty ?? true) && nftsCollectionView.numberOfItems(inSection: 0) == presenter?.takeInitialNftCount() && collectionImage.image != nil {
            removeHud()
        }
    }
    
    private func configureScrollView() {
        scrollView.backgroundColor = .clear
        scrollView.contentInset = UIEdgeInsets(top: -60, left: 0, bottom: 0, right: 0)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureBackButton() {
        if !view.contains(scrollView) { return }
        
        backButton.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack), for: .normal)
        backButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureCollectionImage() {
        if !view.contains(scrollView) { return }
        
        collectionImage.contentMode = .scaleAspectFill
        collectionImage.kf.setImage(with: URL(string: presenter?.takeNftCoverLink() ?? "" )) { [weak self] _ in
            self?.viewReadinessCheck()
        }
        collectionImage.layer.cornerRadius = 12
        collectionImage.layer.masksToBounds = true
        collectionImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(collectionImage)
        NSLayoutConstraint.activate([
            collectionImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            collectionImage.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
    
    private func configureCollectionNameLabel() {
        if !(view.contains(collectionImage) && view.contains(scrollView)) { return }
        
        collectionNameLabel.text = presenter?.takeNftName()
        collectionNameLabel.font = .headline3
        collectionNameLabel.textColor = .ypBlack
        
        collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(collectionNameLabel)
        NSLayoutConstraint.activate([
            collectionNameLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor, constant: 16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureAuthorStaticPartLabel() {
        if !(view.contains(collectionNameLabel) && view.contains(scrollView)) { return }
        
        authorStaticPartLabel.text = NSLocalizedString("catalog.author", comment: "Статическая надпись, представляющая автора коллекции nft") + " "
        authorStaticPartLabel.font = .caption2
        authorStaticPartLabel.textColor = .ypBlack
        
        authorStaticPartLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(authorStaticPartLabel)
        NSLayoutConstraint.activate([
            authorStaticPartLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            authorStaticPartLabel.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 13)
        ])
    }
    
    private func configureAuthorDynamicPartLabel() {
        if !(view.contains(authorStaticPartLabel) && view.contains(scrollView)) { return }
        
        authorDynamicPartLabel.text = ""
        authorDynamicPartLabel.font = .caption1
        authorDynamicPartLabel.textColor = .ypBlueUniversal
        authorDynamicPartLabel.isUserInteractionEnabled = true
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        authorDynamicPartLabel.addGestureRecognizer(guestureRecognizer)
        
        authorDynamicPartLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(authorDynamicPartLabel)
        NSLayoutConstraint.activate([
            authorDynamicPartLabel.leadingAnchor.constraint(equalTo: authorStaticPartLabel.trailingAnchor),
            authorDynamicPartLabel.bottomAnchor.constraint(equalTo: authorStaticPartLabel.bottomAnchor),
            authorDynamicPartLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDescriptionLabel() {
        if !(view.contains(authorStaticPartLabel) && view.contains(scrollView)) { return }
        
        descriptionLabel.text = presenter?.takeNftDescription()
        descriptionLabel.isScrollEnabled = false
        descriptionLabel.isEditable = false
        descriptionLabel.isSelectable = false
        descriptionLabel.font = .caption2
        descriptionLabel.textColor = .ypBlack
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorStaticPartLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNftsCollection() {
        if !(view.contains(descriptionLabel) && view.contains(scrollView)) { return }
        
        nftsCollectionView.backgroundColor = .clear
        
        nftsCollectionView.dataSource = self
        nftsCollectionView.delegate = self
        
        nftsCollectionView.register(CollectionScreenCollectionCell.self)
        
        nftsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nftsCollectionView)
        NSLayoutConstraint.activate([
            nftsCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            nftsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nftsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            nftsCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            nftsCollectionView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    @objc func buttonTap() {
        dismiss(animated: true)
    }
    
    @objc func labelClicked() {
        
    }
}

extension CollectionScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3-9, height: (collectionView.frame.width/3-9)*1.593)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        28
    }
}

extension CollectionScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.takeActualNftCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        presenter?.configureCell(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
}
