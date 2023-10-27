import UIKit

protocol FavouriteNftsCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(id: String)
}

final class FavouriteNftsCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    static var defaultReuseIdentifier: String = "FavouritesNFTCell"
    
    private var model: NFTCell?

    weak var delegate: FavouriteNftsCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(Resources.Images.NFTCollectionCell.likedButton, for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return nameLabel
    }()
    
    private lazy var rateImage: UIImageView = {
        let rateImage = UIImageView()
        return rateImage
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return priceLabel
    }()
    
    private func setupViews() {
        [imageView, nameLabel, rateImage, priceLabel].forEach(contentView.setupView(_:))
        imageView.setupView(likeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
            likeButton.widthAnchor.constraint(equalToConstant: 26),
            likeButton.heightAnchor.constraint(equalToConstant: 22),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            rateImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            rateImage.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            rateImage.widthAnchor.constraint(equalToConstant: 70),
            
            priceLabel.topAnchor.constraint(equalTo: rateImage.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setRateImage(_ number: Int) {
        switch number {
        case 0:
            rateImage.image = Resources.Images.RateImages.zero
        case 1:
            rateImage.image = Resources.Images.RateImages.one
        case 2:
            rateImage.image = Resources.Images.RateImages.two
        case 3:
            rateImage.image = Resources.Images.RateImages.three
        case 4:
            rateImage.image = Resources.Images.RateImages.four
        case 5:
            rateImage.image = Resources.Images.RateImages.five
        default:
            break
        }
    }
    
    @objc func likeButtonTapped() {
        guard let id = model?.id else { return }
        delegate?.didTapLikeButton(id: id)
    }
    
    func setupCellData(_ model: NFTCell) {
        self.model = model
        nameLabel.text = model.name
        setRateImage(model.rating)
        priceLabel.text = "\(model.price) ETH"
        
        if model.isLiked {
            likeButton.setImage(Resources.Images.NFTCollectionCell.likedButton, for: .normal)
        } else {
            likeButton.setImage(Resources.Images.NFTCollectionCell.unlikedButton, for: .normal)
        }
        
        guard let firstImage = model.images.first,
              let imageUrl = URL(string: firstImage) else { return }
        imageView.kf.setImage(with: imageUrl)
    }
}
