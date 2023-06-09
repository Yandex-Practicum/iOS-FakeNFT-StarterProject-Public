//
//  FavoritesNFTCollectionViewCell.swift
//  FakeNFT
//

import UIKit

final class FavoritesNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    weak var delegate: FavoritesNFTCellDelegate?

    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftImageView, nftDataStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var nftDataStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftNameLabel, nftRatingLabel, nftPriceValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        return stackView
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.addSubview(likeButton)
        imageView.isUserInteractionEnabled = true
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 54, y: 6, width: 21, height: 18))
        button.setImage(heartImage?.withTintColor(.redHeartColor, renderingMode: .alwaysOriginal), for: .normal)
        button.contentMode = .center
        button.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        return button
    }()

    private let heartImage = UIImage(systemName: "heart.fill")

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textColorBlack
        return label
    }()

    private lazy var nftRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nftPriceValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .textColorBlack
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
        likeButton.setImage(heartImage?.withTintColor(.redHeartColor, renderingMode: .alwaysOriginal), for: .normal)
    }

    @objc private func likeButtonAction() {
        delegate?.didTapLike(self)
    }

    private func setupConstraints() {
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func makeRatingString(from rating: Int) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: "")
        for count in 1...5 {
            let imageAttachment = NSTextAttachment()
            imageAttachment.bounds = CGRect(origin: .zero, size: CGSize(width: 14, height: 13))
            if count <= rating && rating != 0 {
                imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingStarYellow)
                fullString.append(NSAttributedString(attachment: imageAttachment))
            } else {
                imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingStarLightGray)
                fullString.append(NSAttributedString(attachment: imageAttachment))
            }
        }
        return fullString
    }

    func configCell(from nftViewModel: NFTViewModel) {
        nftImageView.kf.setImage(with: nftViewModel.image)
        nftNameLabel.text = nftViewModel.name
        nftRatingLabel.attributedText = makeRatingString(from: nftViewModel.rating)
        nftPriceValueLabel.text = nftViewModel.price
    }

    func changeLikeButtonImage() {
        likeButton.setImage(heartImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    }
}
