//
//  CollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 03.08.2023.
//

import UIKit
import Kingfisher

final class CollectionScreenViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let buttonBack = UIButton()
    private let image = UIImageView()
    
    var dataModel: CatalogDataModel?
    
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
        UIBlockingProgressHUD.show()
        image.kf.setImage(with: URL(string: dataModel?.cover.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")) { _ in
            UIBlockingProgressHUD.dismiss()
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
        
        collectionNameLabel.text = dataModel?.name
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
        
        authorLabelStaticPart.text = "Автор коллекции: "
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
        
        authorLabelDynamicPart.text = "John Doe" //убрать
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
        
        descriptionLabel.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
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
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    private func configureCollection() {
        collection.backgroundColor = .clear

        collection.dataSource = self
        collection.delegate = self

        collection.register(CollectionScreenCollectionCell.self, forCellWithReuseIdentifier: CollectionScreenCollectionCell.cellReuseIdentifier)

        collection.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            collection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            collection.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            collection.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    @objc func labelClicked() {
        
    }
}

extension CollectionScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 172)
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
        return dataModel?.nfts.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: CollectionScreenCollectionCell.cellReuseIdentifier, for: indexPath) as? CollectionScreenCollectionCell else { return UICollectionViewCell() }
        cell.setNftImage(link: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Biscuit/1.png")
        cell.setRating(rate: 3)
        cell.setNameLabel(name: "Archie")
        cell.setCostLabel(cost: 402)
        return cell
    }
}
