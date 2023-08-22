//
//  CollectionCellView.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit
import SnapKit

final class CollectionCellView: UICollectionViewCell {
    // MARK: - Public Methods
    func configure(with viewModel: NFTCollectionCellViewModel) {
        nftNumberInCollection.text = viewModel.formattedNftsNumber
    }

    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")?
            .withTintColor(.ypBlack, renderingMode: .alwaysOriginal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()

    private let nftCollectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .bodyBold
        label.text = "Коллекция NFT"
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let nftNumberInCollection: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .bodyBold
        return label
    }()

    private let stackViewHorizontal: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

// MARK: - UI
private extension CollectionCellView {
    func addSubviews() {
        stackViewHorizontal.addArrangedSubview(nftCollectionLabel)
        stackViewHorizontal.addArrangedSubview(nftNumberInCollection)
        stackViewHorizontal.addArrangedSubview(imageView)
        contentView.addSubview(stackViewHorizontal)
    }

    func setupConstraints() {
        stackViewHorizontal.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CollectionCellView: ReuseIdentifying { }
