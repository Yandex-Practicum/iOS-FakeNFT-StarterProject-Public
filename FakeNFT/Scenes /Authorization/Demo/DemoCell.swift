import UIKit
import Kingfisher

final class DemoCell: UICollectionViewCell {
    
    // MARK: UI constants and variables
    private lazy var imageNFT: UIImageView = {
        let imageNFT = UIImageView()
        imageNFT.layer.masksToBounds = true
        imageNFT.layer.cornerRadius = 12
        return imageNFT
    }()
    
    private lazy var nameNFT: UILabel = {
        let nameNFT = UILabel()
        nameNFT.textColor = .blackDay
        nameNFT.font = .captionMediumBold
        return nameNFT
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var priceNFT: UILabel = {
        let priceNFT = UILabel()
        priceNFT.textColor = .blackDay
        priceNFT.font = .captionSmallerRegular
        priceNFT.text = L10n.General.price
        return priceNFT
    }()
    
    private lazy var priceCountNFT: UILabel = {
        let priceCountNFT = UILabel()
        priceCountNFT.textColor = .blackDay
        priceCountNFT.font = .captionMediumBold
        return priceCountNFT
    }()
    
    private lazy var nftLikeButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    private lazy var authorName: UILabel = {
        let authorName = UILabel()
        authorName.textColor = .blackDay
        authorName.font = .captionSmallerRegular
        return authorName
    }()
    
    private lazy var isLike: Bool = false
    
    // MARK: - Lifecycle:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setTargets()
        setButtonImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Set Up UI
extension DemoCell {
    private func setupViews() {
        [imageNFT, nameNFT, ratingStackView, priceNFT, priceCountNFT, nftLikeButton, authorName].forEach(contentView.setupView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            ratingStackView.topAnchor.constraint(equalTo: nameNFT.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            authorName.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            authorName.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            priceNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33),
            priceNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 137),
            priceCountNFT.topAnchor.constraint(equalTo: priceNFT.bottomAnchor, constant: 2),
            priceCountNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 137),
            nftLikeButton.topAnchor.constraint(equalTo: imageNFT.topAnchor, constant: 12),
            nftLikeButton.trailingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: -12.25)
        ])
    }
    
    private  func setTargets() {
        nftLikeButton.addTarget(self, action: #selector(setButtonImages), for: .touchUpInside)
    }
    
    // MARK: Methods
    
    func setupCollectionModel(model: NFTCard, author: String) {
        let imageUrl = URL(string: model.images[0])
        let size = CGSize(width: 115, height: 115)
        let resizingProcessor = ResizingImageProcessor(referenceSize: size)
        nameNFT.text = model.name
        priceCountNFT.text = "\(String(model.price)) ETH"
        imageNFT.kf.setImage(with: imageUrl, options: [.processor(resizingProcessor)])
        authorName.text = model.author
        setupRatingStackView(rating: model.rating)
        authorName.text = author
    }
    
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
    
    @objc private func setButtonImages() {
        if isLike {
            isLike = false
            nftLikeButton.setImage(Resources.Images.NFTCollectionCell.likedButton, for: .normal)
        } else {
            isLike = true
            nftLikeButton.setImage(Resources.Images.NFTCollectionCell.unlikedButton, for: .normal)
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
}

extension DemoCell: ReuseIdentifying {
    static var defaultReuseIdentifier = "cellDemo"
}
