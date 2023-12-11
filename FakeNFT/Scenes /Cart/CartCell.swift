//
//  CartCell.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 10.12.2023.
//

import UIKit

final class CartCell: UITableViewCell {
    weak var delegate: CartViewControllerDelegate?
    private var nftID: String?
    private let ratingView = RatingView()

    // MARK: - UiElements
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = NSLocalizedString("Price", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageNFTView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "YPTrash"), for: .normal)
        button.addTarget(self, action: #selector(didDeleteButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configViews()
        configConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc private func didDeleteButtonAction() {
        guard let id = nftID else { return }
        delegate?.removingNFTsFromCart(id: id)
    }

    // MARK: - Methods
    func configureCell() {
        // mock для проверки функционала
        nftID = "test"
        nameLabel.text = "April"
        priceLabel.text = "150,12 ETH"
        imageNFTView.image = UIImage(named: "mock")
        ratingView.rating = 2
    }

    // MARK: - Private methods
    private func configViews() {
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(priceTitleLabel)
        addSubview(imageNFTView)
        addSubview(ratingView)
        contentView.addSubview(deleteButton)
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            imageNFTView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageNFTView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageNFTView.heightAnchor.constraint(equalToConstant: 108),
            imageNFTView.widthAnchor.constraint(equalToConstant: 108),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            priceTitleLabel.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
