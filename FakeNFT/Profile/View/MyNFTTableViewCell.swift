//
//  MyNFTTableViewCell.swift
//  FakeNFT
//

import UIKit
import Kingfisher

final class MyNFTTableViewCell: UITableViewCell, ReuseIdentifying {

    var id: String = ""

    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftImageView, nftDataStackView, nftPriceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var nftDataStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftNameLabel, nftRatingLabel, nftAuthorLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 23, left: 0, bottom: 23, right: 0)
        return stackView
    }()

    private lazy var nftPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftPriceTitleLabel, nftPriceValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 33, left: 0, bottom: 33, right: 0)
        return stackView
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.addSubview(likeButton)
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 79, y: 12, width: 18, height: 16))
        button.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.contentMode = .center
        button.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        return button
    }()

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

    private lazy var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSMutableAttributedString(string: NSLocalizedString("fromAuthor", comment: ""),
                                                         attributes: [.font: UIFont.systemFont(ofSize: 15)])
        label.textColor = .textColorBlack
        return label
    }()

    private lazy var nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .textColorBlack
        label.text = NSLocalizedString("priceTitle", comment: "Price label title text")
        return label
    }()

    private lazy var nftPriceValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textColorBlack
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
    }

    @objc private func likeButtonAction() {

    }

    private func setupConstraints() {
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ])
    }

    func configCell(from nftViewModel: NFTViewModel) {
        nftImageView.kf.setImage(with: nftViewModel.image)
        nftNameLabel.text = nftViewModel.name
        nftRatingLabel.attributedText = nftViewModel.rating
        nftPriceValueLabel.text = nftViewModel.price
        id = nftViewModel.id
    }

    func set(author: String) {
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(NSAttributedString(string: NSLocalizedString("fromAuthor", comment: ""), attributes: [.font: UIFont.systemFont(ofSize: 15)]))
        mutableAttributedString.append(NSAttributedString(string: NSLocalizedString(author, comment: ""), attributes: [.font: UIFont.systemFont(ofSize: 13)]))
        nftAuthorLabel.attributedText = mutableAttributedString
    }
}
