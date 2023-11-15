//
//  CatalogView.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import UIKit
import Kingfisher
import Combine

protocol CatalogCollectionViewDelegate: AnyObject {
    func dismissView()
}

final class CatalogCollectionView: UIView {
    weak var delegate: CatalogCollectionViewDelegate?

    private let reuseIdentifier = "CatalogCollectionCell"
    private let viewModel: CatalogCollectionViewModelProtocol
    private lazy var backButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(named: Constants.backwardPicTitle)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    private let contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private let collectionCoverImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    private let catalogNameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private let authorNameLabel: UILabel = {
        let label = UILabel()

        label.text = Constants.authorLabelText
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private lazy var authorPageLinkButton: UIButton = {
        let button = UIButton()

//        button.setTitle("author", for: .normal)
        button.isHidden = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private let catalogDescriptionLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 9
        layout.itemSize = CGSize(width: 108, height: 192)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.allowsSelection = false

        return collection
    }()
    private lazy var authorLinkAnimationView: UIView = {
        let view = UIView()

        view.isHidden = false
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private var subscribes = [AnyCancellable]()

    init(frame: CGRect, viewModel: CatalogCollectionViewModelProtocol, delegate: CatalogCollectionViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
        setupCollectionCoverImageView()
        startAnimation()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        collectionCoverImageView.kf.cancelDownloadTask()
    }

    private func bind() {
        viewModel.nftsLoaderPuublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }

                collectionView.reloadData()

            }.store(in: &subscribes)

        viewModel.authorPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] author in
                guard let self = self else { return }

                if author != nil {
                    configureAuthor(author)
                }

            }.store(in: &subscribes)
    }

    private func configureAuthor(_ author: Author?) {
        stopAnimation()
        authorPageLinkButton.setTitle(author?.name, for: .normal)
        layoutSubviews()
    }

    private func setupCollectionCoverImageView() {
        collectionCoverImageView.kf.setImage(with: viewModel.catalogCollection.coverURL)
    }

    private func setupUI() {
        collectionView.register(CatalogCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubviews()
        applyConstraints()

        catalogNameLabel.text = viewModel.catalogCollection.name
        catalogDescriptionLabel.text = viewModel.catalogCollection.desription

    }

    private func addSubviews() {
        addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(collectionCoverImageView)
        contentView.addSubview(catalogNameLabel)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(authorLinkAnimationView)
        contentView.addSubview(authorPageLinkButton)
        contentView.addSubview(catalogDescriptionLabel)
        contentView.addSubview(collectionView)

        addSubview(backButton)
    }

    private func applyConstraints() {

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),

            collectionCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionCoverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionCoverImageView.heightAnchor.constraint(equalToConstant: 310),

//            collectionCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            catalogNameLabel.topAnchor.constraint(equalTo: collectionCoverImageView.bottomAnchor, constant: 16),
            catalogNameLabel.leadingAnchor.constraint(equalTo: collectionCoverImageView.leadingAnchor, constant: 16),

            authorNameLabel.topAnchor.constraint(equalTo: catalogNameLabel.bottomAnchor, constant: 13),
            authorNameLabel.leadingAnchor.constraint(equalTo: catalogNameLabel.leadingAnchor),

            authorPageLinkButton.topAnchor.constraint(equalTo: catalogNameLabel.bottomAnchor, constant: 6),
            authorPageLinkButton.leadingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: 4),
            authorPageLinkButton.heightAnchor.constraint(equalToConstant: 28),

            authorLinkAnimationView.topAnchor.constraint(equalTo: catalogNameLabel.bottomAnchor, constant: 6),
            authorLinkAnimationView.leadingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor, constant: 4),
            authorLinkAnimationView.heightAnchor.constraint(equalToConstant: 28),
            authorLinkAnimationView.widthAnchor.constraint(equalToConstant: 100),

            catalogDescriptionLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 5),
            catalogDescriptionLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            catalogDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

//            catalogDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: catalogDescriptionLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: catalogDescriptionLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: catalogDescriptionLabel.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: viewModel.calculateCollectionViewHeight())

//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
//            contentView.heightAnchor.constraint(equalTo: collectionCoverImageView.heightAnchor, multiplier: 1)
        ])
    }

    @objc
    private func backButtonTapped() {
        delegate?.dismissView()
    }

    private func startAnimation() {
        authorLinkAnimationView.isHidden = false
        authorLinkAnimationView.flash()
    }

    private func stopAnimation() {
        authorLinkAnimationView.isHidden = true
        authorPageLinkButton.isHidden = false
    }
}

extension CatalogCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.catalogCollection.nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath) as? CatalogCollectionViewCell else {
                return UICollectionViewCell()
            }

            if viewModel.nftsLoadingIsCompleted {
                let model = viewModel.nfts[indexPath.row]
                cell.setImage(model)
            } else {
                cell.configureCell()
            }

            return cell
        }
}

extension CatalogCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 192)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
