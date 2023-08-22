//
//  UserCell.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 29.07.2023.
//

import UIKit
import Kingfisher

final class UserCell: UICollectionViewCell {
    // MARK: - Public Methods
    func configure(with user: User, number: Int) {
        rankingLabel.text = "\(number + 1)"
        usernameLabel.text = user.username
        nftCountLabel.text = user.ranking
        let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        imageView.kf.setImage(with: user.avatarURL, placeholder: placeholder)
    }

    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    private let rankingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.font = .caption1
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        return label
    }()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .ypLightGray
        return view
    }()

    private let horizontalStackView: UIStackView = {
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
private extension UserCell {
    private func addSubviews() {
        horizontalStackView.addArrangedSubview(imageView)
        horizontalStackView.addArrangedSubview(usernameLabel)
        horizontalStackView.addArrangedSubview(nftCountLabel)

        container.addSubview(horizontalStackView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(container)

        horizontalStackView.setCustomSpacing(16, after: usernameLabel)
    }

    private func setupConstraints() {
        rankingLabel.snp.makeConstraints { make in
            make.width.equalTo(27)
            make.top.bottom.equalTo(contentView).inset(30)
            make.leading.equalTo(contentView).inset(0)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(26)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(28)
        }

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }

        container.snp.makeConstraints { make in
            make.leading.equalTo(rankingLabel.snp.trailing).offset(8)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}

extension UserCell: ReuseIdentifying { }

extension UserCell: AnimatableCollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            highlightAnimation()
        }
    }
}
