//
//  UserCardCellView.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class UserCardCellView: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Public Methods
    func configure(with viewModel: UserCardCellViewModel) {
        imageView.image = .mockUserImage
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.kf.setImage(with: viewModel.avatarURL, placeholder: placeholder)

        layoutIfNeeded()
    }

    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private let stackViewHorizontal: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.alignment = .center
        return view
    }()

    private let stackViewVertical: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
}

// MARK: - UI
private extension UserCardCellView {
    func addSubviews() {
        stackViewHorizontal.addArrangedSubview(imageView)
        stackViewHorizontal.addArrangedSubview(titleLabel)
        stackViewVertical.addArrangedSubview(stackViewHorizontal)
        stackViewVertical.addArrangedSubview(descriptionLabel)

        contentView.addSubview(stackViewVertical)
    }

    func setupConstraints() {
        stackViewVertical.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        imageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.leading.top.equalToSuperview()
        }
    }
}
