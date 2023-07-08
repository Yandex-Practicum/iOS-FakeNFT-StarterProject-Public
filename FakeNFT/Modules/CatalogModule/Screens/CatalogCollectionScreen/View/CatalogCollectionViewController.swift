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
    var onWebView: ((String) -> Void)? { get set }
}

final class CatalogCollectionViewController: UIViewController & CatalogCollectionCoordinatable {

    var onCancel: (() -> Void)?
    var onWebView: ((String) -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    private let viewModel: CatalogCollectionViewModel
    private var diffableDataSource: NftCollectionDSManagerProtocol
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.defaultReuseIdentifier)
        collectionView.delegate = self
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
    
    private lazy var authorDescriptionLabel: AuthorDescriptionLabel = {
        let label = AuthorDescriptionLabel(size: 13, weight: .regular, color: .ypBlack)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
        
        return label
    }()
    
    private lazy var collectionDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
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
        stackView.spacing = 5
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(collectionDescriptionTextView)
        
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: CatalogCollectionViewModel, diffableDataSource: NftCollectionDSManagerProtocol) {
        self.viewModel = viewModel
        self.diffableDataSource = diffableDataSource
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
        createCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
}

// MARK: - Ext @Objc
@objc private extension CatalogCollectionViewController {
    func cancelTapped() {
        onCancel?()
    }
    
    func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let author = viewModel.author else { return }
        onWebView?(author.website)
    }
}

// MARK: - Ext Private
private extension CatalogCollectionViewController {
    func bind() {
        viewModel.$nftCollection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] collection in
                self?.loadAuthorData(for: collection)
                self?.updateUI(with: collection)
            }
            .store(in: &cancellables)
        
        viewModel.$visibleNfts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rows in
                self?.updateCollectionView(with: rows)
            }
            .store(in: &cancellables)
        
        viewModel.$author
            .receive(on: DispatchQueue.main)
            .sink { [weak self] author in
                self?.updateAuthorTextLabelLink(for: author)
            }
            .store(in: &cancellables)
    }
    
    func loadAuthorData(for collection: NftCollection) {
        viewModel.loadAuthorData(of: collection)
    }
    
    func createCollectionView() {
        diffableDataSource.createDataSource(with: collectionView, with: viewModel.visibleNfts)
        setOnCartClosure()
        setOnLikeClosure()
    }
    
    func setOnCartClosure() {
        diffableDataSource.onCartHandler = { [weak viewModel] id in
            viewModel?.addOrDeleteNftFromCart(with: id)
        }
    }
    
    func setOnLikeClosure() {
        diffableDataSource.onLikeHandler = { [weak viewModel] id in
            viewModel?.addOrDeleteLike(to: id)
        }
    }
    
    func updateUI(with collection: NftCollection) {
        updateCoverImage(for: collection)
        updateTitleLabelText(for: collection)
        updateAuthorTextLabel(for: collection)
        updateDescriptionTextView(for: collection)
        updateSingleNfts(for: collection)
        
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
    
    func updateAuthorTextLabel(for collection: NftCollection) {
        authorDescriptionLabel.setupAttributedText(authorName: collection.author)
    }
    
    func updateAuthorTextLabelLink(for author: Author?) {
        guard let author else { return }
        authorDescriptionLabel.setupAttributedText(authorName: author.name, authorId: author.id)
    }
    
    func updateDescriptionTextView(for collection: NftCollection) {
        collectionDescriptionTextView.text = collection.description
        updateTextViewHeight()
    }
    
    func updateTextViewHeight() {
        let size = collectionDescriptionTextView.sizeThatFits(CGSize(width: collectionDescriptionTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        collectionDescriptionTextView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    func updateSingleNfts(for collection: NftCollection) {
        viewModel.updateNfts(from: collection)
    }
    
    func updateCollectionView(with data: [VisibleSingleNfts]) {
        diffableDataSource.updateCollection(with: data)
    }
}

// MARK: - Ext DelegateFlowLayout
extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width / GridItemSize.threeInRow.rawValue - 1), height: 170)
    }
}

// MARK: - Ext Constraints
private extension CatalogCollectionViewController {
    func setupConstraints() {
        setupCoverImageView()
        setupMainStackView()
        setupCollectionView()
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
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
