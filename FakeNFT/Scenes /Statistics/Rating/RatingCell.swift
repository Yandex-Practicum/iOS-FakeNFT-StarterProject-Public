//
//  RatingCell.swift
//  FakeNFT
//
//  Created by Сергей on 24.04.2024.
//

import UIKit
import Kingfisher

final class RatingCell: UICollectionViewCell {

    static let identifier = "RatingTableViewCell"

    // MARK: - private properties

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .segmentInactive
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(indexPath: IndexPath, person: Person) {
        let url = URL(string: person.avatar)
        ratingLabel.text = "\(indexPath.row + 1)"
        avatarImage.kf.setImage(with: url, placeholder: UIImage(named: "stub"))
        nameLabel.text = person.name
        nftCountLabel.text = "\(person.nfts.count)"
    }

    private func setupViews() {
        [ratingLabel, cellView].forEach {
            contentView.addSubview($0)
        }

        [avatarImage, nameLabel, nftCountLabel].forEach {
            cellView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 27),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            avatarImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 28),
            avatarImage.widthAnchor.constraint(equalToConstant: 28),
            nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            nftCountLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            nftCountLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            nftCountLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
        ])
    }
}
