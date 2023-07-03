//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import UIKit
import Combine

protocol CatalogCollectionCoordinatable {
    var onCancel: (() -> Void)? { get set }
    var onWebView: (() -> Void)? { get set }
}

final class CatalogCollectionViewController: UIViewController & CatalogCollectionCoordinatable {

    var onCancel: (() -> Void)?
    var onWebView: (() -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    let viewModel: CatalogCollectionViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.defaultReuseIdentifier)
        return collectionView
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    private lazy var titleLabel: CustomLabel = {
        let label = CustomLabel(size: 22, weight: .bold, color: .ypBlack)
        return label
    }()
    
    private lazy var authorDescriptionLabel: CustomLabel = {
        let label = CustomLabel(size: 13, weight: .regular, color: .ypBlack)
        
        let attrString = NSMutableAttributedString()
        let firstLineAttrText = NSMutableAttributedString(string: NSLocalizedString("Автор коллекции: ", comment: ""))
        let secondLineAttrText = NSMutableAttributedString(string: NSLocalizedString("John Doe", comment: ""))
        let range = NSRange(location: 0, length: secondLineAttrText.length)
        
        secondLineAttrText.addAttribute(.link, value: K.Links.authorInformationLink, range: range)
        secondLineAttrText.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: range)
        attrString.append(firstLineAttrText)
        attrString.append(secondLineAttrText)
        
        label.attributedText = attrString
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
        
        return label
    }()
    
    private lazy var collectionDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)

        return textView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorDescriptionLabel)
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(collectionDescriptionTextView)
        
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: CatalogCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupLeftNavBarItem(with: nil, action: #selector(cancelTapped))
        setupConstraints()
        bind()
        createCollectionView()
    }
}

@objc private extension CatalogCollectionViewController {
    func cancelTapped() {
        onCancel?()
    }
    
    func labelTapped(_ gesture: UITapGestureRecognizer) {
        onWebView?()
    }
}

// MARK: - Ext Private
private extension CatalogCollectionViewController {
    func bind() {
        viewModel.$nftCollection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collection in
                self?.updateUI(with: collection)
            }
            .store(in: &cancellables)
    }
    
    func createCollectionView() {
        
    }
    
    func updateUI(with collection: NftCollection) {
        updateCoverImage(for: collection)
        updateTitleLabelText(for: collection)
        updateDescriptionTextView(for: collection)
        updateCollectionView(for: collection)
        
    }
    
    func updateCoverImage(for collection: NftCollection) {
        guard
            let encodedStringUrl = collection.cover.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        coverImageView.setImage(from: url)
    }
    
    func updateTitleLabelText(for collection: NftCollection) {
        titleLabel.text = collection.name
    }
    
    func updateDescriptionTextView(for collection: NftCollection) {
        collectionDescriptionTextView.text = collection.description
    }
    
    func updateCollectionView(for collection: NftCollection) {
        
    }
}

// MARK: - Ext Constraints
private extension CatalogCollectionViewController {
    func setupConstraints() {
        setupCoverImageView()
        setupMainStackView()
    }
    
    func setupCoverImageView() {
        view.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.0)
        ])
    }
    
    func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 136)
        ])
    }
}
