import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    static let reuseIdentifier = "cartNFTTableViewCell"

    private lazy var imageViewNFT: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingStarStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .textPrimary
        label.text = Constants.priceLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var infoNFTView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.deleteFromBasketPicTitle), for: .normal)
        button.tintColor = .textPrimary
        button.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        addImageViewNFT()
        addInfoNFTView()
        addTitleLabel()
        addRatingStarStackView()
        addPriceTitleLabel()
        addPriceLabel()
        addDeleteButton()
    }

    private func addImageViewNFT() {
       contentView.addSubview(imageViewNFT)
        NSLayoutConstraint.activate([
            imageViewNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewNFT.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewNFT.widthAnchor.constraint(equalToConstant: 108),
            imageViewNFT.heightAnchor.constraint(equalToConstant: 108)
            ])
    }

    private func addInfoNFTView() {
        contentView.addSubview(infoNFTView)
        NSLayoutConstraint.activate([
            infoNFTView.leadingAnchor.constraint(equalTo: imageViewNFT.trailingAnchor, constant: 16),
            infoNFTView.topAnchor.constraint(equalTo: imageViewNFT.topAnchor, constant: 8),
            infoNFTView.bottomAnchor.constraint(equalTo: imageViewNFT.bottomAnchor, constant: -8)
        ])
    }

    private func addTitleLabel() {
        infoNFTView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: infoNFTView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: infoNFTView.topAnchor)
        ])
    }

    private func addRatingStarStackView() {
        infoNFTView.addSubview(ratingStarStackView)
        NSLayoutConstraint.activate([
            ratingStarStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingStarStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }

    private func addPriceTitleLabel() {
        infoNFTView.addSubview(priceTitleLabel)
        NSLayoutConstraint.activate([
            priceTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingStarStackView.bottomAnchor, constant: 10)
        ])
    }

    private func addPriceLabel() {
        infoNFTView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 5)
        ])
    }

    private func addDeleteButton() {
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func getRating(from rating: Int) {
        ratingStarStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        (0..<rating).forEach { _ in
            let imageView = createStarImageView(active: true)
            ratingStarStackView.addArrangedSubview(imageView)
        }
        ((rating + 1)...5).forEach { _ in
            let imageView = createStarImageView(active: false)
            ratingStarStackView.addArrangedSubview(imageView)
        }
    }

    private func createStarImageView(active: Bool) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = active ? UIImage(named: Constants.starActivePicTitle)
        : UIImage(named: Constants.starInactivePicTitle)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func configure(with model: Nft) {
        contentView.backgroundColor = .systemBackground
        imageViewNFT.kf.setImage(with: model.images.first)
        self.titleLabel.text = model.name
        self.priceLabel.text = "\(model.price) ETH"
        getRating(from: model.rating)
    }

    @objc private func tapDeleteButton() {
    }
}
