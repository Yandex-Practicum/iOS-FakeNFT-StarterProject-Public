import UIKit
import Kingfisher

final class NFTCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: Public Dependencies:
    weak var delegate: NFTCollectionCellDelegate?
    
    // MARK: - Constants and Variables:
    private var nftModel: NFTCell? {
        didSet {
            guard let nftModel = nftModel else { return }
            let urlString = nftModel.images[0]
            let size = CGSize(width: contentView.frame.width, height: 108)
            let processor = DownsamplingImageProcessor(size: size) |> RoundCornerImageProcessor(cornerRadius: 12)
            
            nftLikeButton.layer.removeAllAnimations()
            cartButton.layer.removeAllAnimations()
            
            if let url = URL(string: urlString) {
                nftImageView.kf.indicatorType = .activity
                nftImageView.kf.setImage(with: url,
                                         options: [.processor(processor),
                                                   .transition(.fade(1)),
                                                   .cacheOriginalImage])
                nftNameLabel.text = nftModel.name
                nftPriceLabel.text = "(\(nftModel.price) ETH)"
                setButtonImages()
                if ratingStackView.subviews.count == 0 {
                    setupRatingStackView(rating: nftModel.rating)
                }
            }
        }
    }
    
    // MARK: UI:
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .lightGrayDay
        
        return imageView
    }()
    
    private lazy var nftLikeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var nftLikeButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .captionMediumBold
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .captionSmallestMedium
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .whiteDay
        
        return imageView
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentMode = .center
        
        return button
    }()
    
    static var defaultReuseIdentifier = "NFTCollectionViewCell"
    
    // MARK: - Lifecycle:
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        
        setupViews()
        setupConstraints()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods:
    func setupNFTModel(model: NFTCell) {
        DispatchQueue.main.async {
            self.nftModel = model
        }
    }
    
    func getNFTModel() -> NFTCell? {
        nftModel
    }
    
    // MARK: - Private Methods:
    private func setupRatingStackView(rating: Int) {
        (1...5).forEach { [weak self] number in
            guard let self = self else { return }
            
            if number <= rating {
                let goldStar = UIImageView(image: Resources.Images.NFTCollectionCell.goldRatingStar)
                self.ratingStackView.addArrangedSubview(goldStar)
            } else {
                let grayStar = UIImageView(image: Resources.Images.NFTCollectionCell.grayRatingStar)
                self.ratingStackView.addArrangedSubview(grayStar)
            }
        }
    }
    
    private func setButtonImages() {
        if nftModel?.isLiked == true {
            nftLikeButton.setImage(Resources.Images.NFTCollectionCell.likedButton, for: .normal)
        } else {
            nftLikeButton.setImage(Resources.Images.NFTCollectionCell.unlikedButton, for: .normal)
        }
        
        if nftModel?.isAddedToCard == true {
            cartButton.setImage(Resources.Images.NFTCollectionCell.removeFromBasket, for: .normal)
        } else {
            cartButton.setImage(Resources.Images.NFTCollectionCell.putInBasket, for: .normal)
        }
    }
    
    private func setLikeButtonImageWithAnimate() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.nftLikeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.nftLikeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    private func setCartButtonImageWithAnimate() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.cartButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.cartButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    // MARK: - Objc Methods:
    @objc private func likeButtonDidTapped() {
        delegate?.likeButtonDidTapped(cell: self)
        setLikeButtonImageWithAnimate()
    }
    
    @objc private func addToCartButtonDidTapped() {
        delegate?.addToCardButtonDidTapped(cell: self)
        setCartButtonImageWithAnimate()
    }
}

// MARK: - Setup Views:
extension NFTCollectionCell {
    private func setupViews() {
        backgroundColor = .whiteDay
        
        [nftImageView, nftLikeButton, ratingStackView, nftNameLabel,
         nftPriceLabel, cartImageView, cartButton].forEach(contentView.setupView)
        
        nftImageView.setupView(nftLikeImageView)
    }
}

// MARK: - Setup Constraints:
extension NFTCollectionCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nftLikeImageView.heightAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.widthAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            nftLikeButton.heightAnchor.constraint(equalToConstant: 18),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 22),
            nftLikeButton.centerXAnchor.constraint(equalTo: nftLikeImageView.centerXAnchor),
            nftLikeButton.centerYAnchor.constraint(equalTo: nftLikeImageView.centerYAnchor),
            
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cartImageView.heightAnchor.constraint(equalToConstant: 40),
            cartImageView.widthAnchor.constraint(equalToConstant: 40),
            cartImageView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            cartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.centerXAnchor.constraint(equalTo: cartImageView.centerXAnchor),
            cartButton.centerYAnchor.constraint(equalTo: cartImageView.centerYAnchor)
        ])
    }
}

// MARK: - Setup Targets:
extension NFTCollectionCell {
    private func setupTargets() {
        nftLikeButton.addTarget(self, action: #selector(likeButtonDidTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(addToCartButtonDidTapped), for: .touchUpInside)
    }
}
