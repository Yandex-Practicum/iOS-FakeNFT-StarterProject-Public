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
    private let buttonBack = UIButton()
    private let image = UIImageView()
    private let collectionNameLabel = UILabel()
    private let authorLabelStaticPart = UILabel()
    private let authorLabelDynamicPart = UILabel()
    private let descriptionLabel = UITextView()
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureScrollView()
        configureImage()
        configureButton()
        configureNameLabel()
        configureAuthorLabelStaticPart()
        configureAuthorLabelDynamicPart()
        configureDescriptionLabel()
        configureCollection()
        
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
        authorLabelDynamicPart.text = AuthorNetworkService.shared.author?.name
        viewReadinessCheck()
    }
    
    func updateCollection(oldCount: Int, newCount: Int) {
        collection.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            collection.insertItems(at: indexPaths)
        } completion: { _ in }
    }
    
    func viewReadinessCheck() {
        if !(authorLabelDynamicPart.text?.isEmpty ?? true) && collection.numberOfItems(inSection: 0) == presenter?.takeInitialNftCount() && image.image != nil {
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
    
    private func configureButton() {
        buttonBack.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack), for: .normal)
        buttonBack.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(buttonBack)
        NSLayoutConstraint.activate([
            buttonBack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonBack.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 9),
            buttonBack.heightAnchor.constraint(equalToConstant: 24),
            buttonBack.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureImage() {
        image.contentMode = .scaleAspectFill
        image.kf.setImage(with: URL(string: presenter?.takeNftCoverLink() ?? "" )) { [weak self] _ in
            self?.viewReadinessCheck()
        }
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        image.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            image.topAnchor.constraint(equalTo: scrollView.topAnchor),
            image.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            image.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
    
    private func configureNameLabel() {
        if !view.contains(image) { return }
        
        collectionNameLabel.text = presenter?.takeNftName()
        collectionNameLabel.font = .headline3
        collectionNameLabel.textColor = .ypBlack
        
        collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(collectionNameLabel)
        
        NSLayoutConstraint.activate([
            collectionNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionNameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            collectionNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureAuthorLabelStaticPart() {
        if !view.contains(collectionNameLabel) { return }
        authorLabelStaticPart.text = NSLocalizedString("catalog.author", comment: "Статическая надпись, представляющая автора коллекции nft") + " "
        authorLabelStaticPart.font = .caption2
        authorLabelStaticPart.textColor = .ypBlack
        authorLabelStaticPart.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(authorLabelStaticPart)
        NSLayoutConstraint.activate([
            authorLabelStaticPart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            authorLabelStaticPart.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 13)
        ])
    }
    
    private func configureAuthorLabelDynamicPart() {
        if !view.contains(authorLabelStaticPart) { return }
        authorLabelDynamicPart.text = ""
        authorLabelDynamicPart.font = .caption1
        authorLabelDynamicPart.textColor = .ypBlueUniversal
        authorLabelDynamicPart.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        authorLabelDynamicPart.addGestureRecognizer(guestureRecognizer)
        authorLabelDynamicPart.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(authorLabelDynamicPart)
        NSLayoutConstraint.activate([
            authorLabelDynamicPart.leadingAnchor.constraint(equalTo: authorLabelStaticPart.trailingAnchor),
            authorLabelDynamicPart.bottomAnchor.constraint(equalTo: authorLabelStaticPart.bottomAnchor),
            authorLabelDynamicPart.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDescriptionLabel() {
        if !view.contains(authorLabelStaticPart) { return }
        
        descriptionLabel.text = presenter?.takeNftDescription()
        descriptionLabel.isScrollEnabled = false
        descriptionLabel.font = .caption2
        descriptionLabel.textColor = .ypBlack
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.isEditable = false
        descriptionLabel.isSelectable = false
        descriptionLabel.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabelStaticPart.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCollection() {
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(CollectionScreenCollectionCell.self)
        collection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            collection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            collection.heightAnchor.constraint(equalToConstant: 500)
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
        presenter?.takeNftCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        presenter?.configureCell(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
}
