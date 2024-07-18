import Foundation
import UIKit
import Kingfisher

final class StatisticCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private let backgroundContainer = UIView()
    private let ratingLabel = UILabel()
    private let nameLabel = UILabel()
    private let numberNftLabel = UILabel()
    private let profileImage = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "YPWhite")
        setupBackgroundContainer()
        setupIndexLabel()
        setupNameLabel()
        setupRatingLabel()
        setupProfileImage()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateNameLabel(name: String) {
        nameLabel.text = name
    }
    
    func updateRatingLabel(rating: String) {
        ratingLabel.text = rating
        
    }
    
    func updateNumberNftLabel(numberNft: String) {
        numberNftLabel.text = numberNft
    }
    
    func updateProfileImage(avatar: URL) {
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: avatar, placeholder: UIImage(named: "ProfileImage"))
    }
    
    func putPlugProfileImage() {
        profileImage.image = UIImage(named: "ProfileImage")
    }
    
    // MARK: - Public Methods
    private func setupBackgroundContainer() {
        contentView.addSubview(backgroundContainer)
        backgroundContainer.layer.cornerRadius = 12
        backgroundContainer.layer.masksToBounds = true
        backgroundContainer.backgroundColor = UIColor(named: "YPLightGray")
    }
    
    private func setupIndexLabel() {
        contentView.addSubview(ratingLabel)
        ratingLabel.font = UIFont.systemFont(ofSize: 15)
        ratingLabel.textAlignment = .center
    }
    
    private func setupNameLabel() {
        backgroundContainer.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private func setupRatingLabel() {
        backgroundContainer.addSubview(numberNftLabel)
        numberNftLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        numberNftLabel.textAlignment = .center
    }
    
    private func setupProfileImage() {
        backgroundContainer.addSubview(profileImage)
        profileImage.layer.cornerRadius = 12
        profileImage.layer.masksToBounds = true
    }
    
    private func setupConstraint() {
        [backgroundContainer, ratingLabel, nameLabel, numberNftLabel, profileImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            backgroundContainer.topAnchor.constraint(equalTo: topAnchor),
            backgroundContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            backgroundContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 52),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -70),
            numberNftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberNftLabel.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 254),
            numberNftLabel.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -16),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            profileImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            profileImage.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: 16),
            profileImage.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -264)
        ])
    }
}
