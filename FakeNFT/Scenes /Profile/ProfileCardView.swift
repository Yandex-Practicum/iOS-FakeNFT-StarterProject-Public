//
//  ProfileCardView.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 19.03.2025.
//
import UIKit
import Kingfisher

final class ProfileCardView: UIView {
    
    // MARK: - Private Properties
    
    private let avatarImageSize = CGSize(width: 70, height: 70)
    private let leadingInset = 16.0
    private let trailingInset = -16.0
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.widthAnchor.constraint(equalToConstant: avatarImageSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: avatarImageSize.height).isActive = true
        imageView.layer.cornerRadius = avatarImageSize.height / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setNameText(_ text: String?) {
        nameLabel.text = text
    }
    
    func setDescriptionText(_ text: String?) {
        descriptionLabel.text = text
    }
    
    func setAvatarImage(url: URL) {
        let options: KingfisherOptionsInfo = [
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url, options: options)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(stackView)
        addSubview(descriptionLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingInset),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingInset),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
