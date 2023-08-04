//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import UIKit
import Combine

protocol CatalogCollectionCoordinatable {
    var onWebView: ((String) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

final class CatalogCollectionViewController: UIViewController & CatalogCollectionCoordinatable & Reloadable {
    
    var onWebView: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    private let viewModel: CatalogCollectionViewModel
    private var diffableDataSource: GenericCollectionViewDataSourceProtocol & CollectionViewDataSourceCoordinatable
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .ypWhite
        collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: CatalogCollectionViewCell.defaultReuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
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
    
    private lazy var collectionDescriptionTextView: DescriptionTextView = {
        let textView = DescriptionTextView()
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
    init(viewModel: CatalogCollectionViewModel, diffableDataSource: GenericCollectionViewDataSourceProtocol & CollectionViewDataSourceCoordinatable) {
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
        setupLeftNavBarItem(title: nil, action: #selector(cancelTapped))
        setupConstraints()
        createCollectionView()
        reload()
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
    
    func reload() {
        viewModel.load()
    }
}

// MARK: - Ext @Objc
@objc private extension CatalogCollectionViewController {
    func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let author = viewModel.author else { return }
        onWebView?(author.website)
    }
}

// MARK: - Bind
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
        
        viewModel.$requestResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestResult in
                guard let self else { return }
                self.showOrHideAnimation(loadingView, for: requestResult)
            }
            .store(in: &cancellables)
        
        viewModel.$requestError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.headOnError(error)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Ext UpdateUI
private extension CatalogCollectionViewController {
    func loadAuthorData(for collection: CatalogMainScreenCollection) {
        viewModel.loadAuthorData(of: collection)
    }
    
    func updateUI(with collection: CatalogMainScreenCollection) {
        updateCoverImage(for: collection)
        updateTitleLabelText(for: collection)
        updateAuthorTextLabel(for: collection)
        updateDescriptionTextView(for: collection)
        
    }
    
    func updateCoverImage(for collection: CatalogMainScreenCollection) {
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
    
    func updateTitleLabelText(for collection: CatalogMainScreenCollection) {
        titleLabel.text = collection.name
    }
    
    func updateAuthorTextLabel(for collection: CatalogMainScreenCollection) {
        authorDescriptionLabel.setupAttributedText(authorName: collection.author)
    }
    
    func updateDescriptionTextView(for collection: CatalogMainScreenCollection) {
        collectionDescriptionTextView.text = collection.description
        updateTextViewHeight()
    }
    
    func updateTextViewHeight() {
        let size = collectionDescriptionTextView.sizeThatFits(CGSize(width: collectionDescriptionTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        collectionDescriptionTextView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}

// MARK: - Ext Error
private extension CatalogCollectionViewController {
    func headOnError(_ error: Error?) {
        guard let error else { return }
        onError?(error)
    }
}

// MARK: - Data Source
private extension CatalogCollectionViewController {
    func createCollectionView() {
        diffableDataSource.createDataSource(with: collectionView, from: viewModel.visibleNfts)
        setOnCartClosure()
        setOnLikeClosure()
    }
    
    func updateCollectionView(with data: [VisibleSingleNfts]) {
        diffableDataSource.updateCollection(with: data)
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
}

// MARK: - Ext AuthorLink
private extension CatalogCollectionViewController {
    func updateAuthorTextLabelLink(for author: Author?) {
        guard let author else { return }
        authorDescriptionLabel.setupAttributedText(authorName: author.name, authorId: author.id)
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
        setupLoadingView()
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
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            loadingView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
