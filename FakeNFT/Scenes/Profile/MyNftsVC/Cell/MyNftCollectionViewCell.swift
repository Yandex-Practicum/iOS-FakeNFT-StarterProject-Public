import UIKit

protocol MyNFTCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(id: String)
}

final class MyNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    static let defaultReuseIdentifier = "MyNFTCell"
    
    private var model: NFTCell?

    weak var delegate: MyNFTCollectionViewCellDelegate?
    
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
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 12
        imageView.kf.indicatorType = .activity
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(Resources.Images.NFTCollectionCell.unlikedButton, for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return nameLabel
    }()
    
    private lazy var rateImage: UIImageView = {
        let rateImage = UIImageView()
        return rateImage
    }()
    
    private lazy var fromLabel: UILabel = {
        let fromLabel = UILabel()
        fromLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return fromLabel
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let priceTitleLabel = UILabel()
        priceTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        priceTitleLabel.text = NSLocalizedString("general.price", tableName: "Localizable", comment: "price")
        return priceTitleLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return priceLabel
    }()
    
    private func setupViews() {
        [imageView, nameLabel, rateImage, fromLabel, priceTitleLabel, priceLabel].forEach(contentView.setupView(_:))
        imageView.setupView(likeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 78),
            
            rateImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            rateImage.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            rateImage.widthAnchor.constraint(equalToConstant: 78),
            
            fromLabel.topAnchor.constraint(equalTo: rateImage.bottomAnchor, constant: 4),
            fromLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            fromLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: 39),
            
            priceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33),
            priceTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    @objc func likeButtonTapped() {
        guard let id = model?.id else { return }
        delegate?.didTapLikeButton(id: id)
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
    
    // MARK: - Methods
    
    func setupCellData(_ model: NFTCell) {
        self.model = model
        nameLabel.text = model.name
        setRateImage(model.rating)
        fromLabel.text = model.author
        priceLabel.text = "\(model.price) ETH"
        
        let likeButtonImage = model.isLiked ?
                Resources.Images.NFTCollectionCell.likedButton :
                Resources.Images.NFTCollectionCell.unlikedButton

        likeButton.setImage(likeButtonImage, for: .normal)
        
        guard let firstImage = model.images.first,
              let imageUrl = URL(string: firstImage) else { return }
        imageView.kf.setImage(with: imageUrl)
    }
}
