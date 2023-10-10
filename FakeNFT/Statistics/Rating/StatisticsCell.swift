//
//  StatisticsCell.swift
//  FakeNFT
//

import UIKit
import Kingfisher

final class StatisticsCell: UITableViewCell {
    static let identifier = "StatisticsCell"
 // MARK: - UI
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .nftBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backgroundViewCell: UIView = {
        let view = UIView()
        view.backgroundColor = .nftLightgrey
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var userImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        image.tintColor = .nftGrayUniversal
        image.layer.cornerRadius = 14
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline2
        label.textColor = .nftBlack
        return label
    }()
    
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline2
        label.textColor = .nftBlack
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - AUTOLayouts
    private func setupCell() {
        [ratingLabel, backgroundViewCell].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        [userImage, nameLabel, collectionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            backgroundViewCell.addSubview($0)
        }
        
        backgroundColor = .nftWhite
        
        NSLayoutConstraint.activate([
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 27),
            
            backgroundViewCell.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            backgroundViewCell.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            backgroundViewCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundViewCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            userImage.heightAnchor.constraint(equalToConstant: 28),
            userImage.widthAnchor.constraint(equalToConstant: 28),
            userImage.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 16),
            userImage.centerYAnchor.constraint(equalTo: backgroundViewCell.centerYAnchor),

            nameLabel.centerYAnchor.constraint(equalTo: backgroundViewCell.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 8),

            collectionLabel.centerYAnchor.constraint(equalTo: backgroundViewCell.centerYAnchor),
            collectionLabel.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -16)
        ])
    }
// MARK: - Configure
    func configure(model: User) {
        ratingLabel.text = model.rating
        userImage.kf.indicatorType = .activity
        if let url = URL(string: model.avatar) {
            userImage.kf.setImage(with: url,
                                  placeholder: UIImage(named: "person.crop.circle.fill"))
        }
        nameLabel.text = model.name
        collectionLabel.text = String(model.nfts.count)
    }
}
