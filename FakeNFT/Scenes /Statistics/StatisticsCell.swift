//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit
import Kingfisher

final class StatisticsCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsCell"

    private static var photoPlaceholder: UIImage = {
        let systemName = "person.crop.circle.fill"
        if #available(iOS 15.0, *) {
            let config = UIImage.SymbolConfiguration(paletteColors: [.segmentInactive, .segmentActive])
            return UIImage(systemName: systemName, withConfiguration: config)!
        } else {
            return UIImage(systemName: systemName)!
        }
    }()

    private lazy var ratingTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    private lazy var coloredView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .segmentInactive
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var nftCountTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with model: StatisticsCellModel) {
        ratingTitle.text = model.rating
        nameView.text = model.name
        nftCountTitle.text = model.nftCount
        photoView.kf.indicatorType = .none
        photoView.kf.setImage(
                with: model.photoURL,
                placeholder: StatisticsCell.photoPlaceholder,
                options: [.cacheSerializer(FormatIndicatedCacheSerializer.png), .cacheMemoryOnly])  // TODO: assert png
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        isUserInteractionEnabled = true

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(ratingTitle)
        contentView.addSubview(coloredView)
        coloredView.addSubview(photoView)
        coloredView.addSubview(nameView)
        coloredView.addSubview(nftCountTitle)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    contentView.heightAnchor.constraint(equalToConstant: 80 + Constants.bottomMargin),

                    ratingTitle.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
                    ratingTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    ratingTitle.widthAnchor.constraint(equalToConstant: 20),

                    coloredView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    coloredView.leadingAnchor.constraint(equalTo: ratingTitle.trailingAnchor, constant: 8),
                    coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    coloredView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                        constant: -Constants.bottomMargin),

                    photoView.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
                    photoView.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 16),
                    photoView.widthAnchor.constraint(equalToConstant: 28),
                    photoView.heightAnchor.constraint(equalToConstant: 28),

                    nameView.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
                    nameView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 8),
                    nameView.widthAnchor.constraint(greaterThanOrEqualToConstant: 186),

                    nftCountTitle.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
                    nftCountTitle.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -16),
                    nftCountTitle.leadingAnchor.constraint(greaterThanOrEqualTo: nameView.trailingAnchor, constant: 27)
                ]
        )
    }

}

extension StatisticsCell {
    private enum Constants {
        static let bottomMargin: CGFloat = 8
    }
}
