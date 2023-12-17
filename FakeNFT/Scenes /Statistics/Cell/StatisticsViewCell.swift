//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit
import Kingfisher

final class StatisticsViewCell: UITableViewCell, ReuseIdentifying {
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
        label.textAlignment = .right
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

    override func awakeFromNib() {
        super.awakeFromNib()

        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if let hitView = hitView, hitView.isDescendant(of: coloredView) {
            return hitView
        }
        return nil
    }

    func configure(with model: StatisticsCellModel) {
        ratingTitle.text = String(model.rating)
        nameView.text = model.name
        nftCountTitle.text = String(model.nftCount)
        photoView.kf.indicatorType = .none
        photoView.kf.setImage(
            with: model.photoURL,
            placeholder: StatisticsViewCell.photoPlaceholder,
            options: [.cacheSerializer(FormatIndicatedCacheSerializer.jpeg), .cacheMemoryOnly])
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
                ratingTitle.centerYAnchor.constraint(equalTo: coloredView.centerYAnchor),
                ratingTitle.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                ratingTitle.widthAnchor.constraint(equalToConstant: 27),

                coloredView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                coloredView.leadingAnchor.constraint(equalTo: ratingTitle.trailingAnchor, constant: 8),
                coloredView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                coloredView.heightAnchor.constraint(equalToConstant: 80),

                contentView.heightAnchor.constraint(equalTo: coloredView.heightAnchor,
                                                    constant: Constants.bottomMargin),

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

extension StatisticsViewCell {
    private enum Constants {
        static let bottomMargin: CGFloat = 8
    }
}
