import UIKit

protocol NFTCollectionCellDelegate: AnyObject {
    func nftCellDidTapFavorite(_ cell: NFTCollectionCell)
    func nftCellDidTapCart(_ cell: NFTCollectionCell)
}

final class NFTCollectionCell: UICollectionViewCell {
    
    private enum NFTCellLayout {
        static let cornerRadius: CGFloat = 12
        
        static let imageHeight: CGFloat = 108
        static let imageWidth: CGFloat = 108
        
        static let likeButtonWidth: CGFloat = 42
        static let likeButtonHeight: CGFloat = 42
        static let likeButtonTrailingOffset: CGFloat = 0
        
        static let starSize: CGFloat = 12
        static let starSpacing: CGFloat = 2
        static let ratingTopSpacing: CGFloat = 8
        static let ratingHeight: CGFloat = 12
        static let ratingWidth: CGFloat = 68
        
        static let labelTopSpacing: CGFloat = 4
        static let priceTopSpacing: CGFloat = 2
        static let labelToCartSpacing: CGFloat = -8
        
        static let bottomPadding: CGFloat = -8
        
        static let cartButtonWidth: CGFloat = 40
        static let cartButtonHeight: CGFloat = 40
        static let cartButtonTrailing: CGFloat = -4
    }
    
    // MARK: - Subviews
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let cartButton = UIButton(type: .system)
    private let ratingView = SimpleRatingView(
        starSize: NFTCellLayout.starSize,
        spacing: NFTCellLayout.starSpacing
    )
    
    // MARK: - Properties
    weak var delegate: NFTCollectionCellDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    struct ViewModel {
        let title: String
        let author: String
        let priceText: String
        let isFavorite: Bool
        let inCart: Bool
        let image: UIImage?
        let rating: Int
    }
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.priceText
        imageView.image = viewModel.image
        
        if viewModel.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .redUniversal
        } else {
            favoriteButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)
            favoriteButton.tintColor = .white
        }
        
        let cartImageName = viewModel.inCart ? "BasketDel" : "BasketAdd"
        let cartImage = UIImage(named: cartImageName)
        cartButton.setImage(cartImage, for: .normal)
        
        ratingView.setRating(viewModel.rating)
    }

    
    // MARK: - Setup
    private func setupViews() {
        contentView.backgroundColor = .whiteUniversal
        contentView.layer.cornerRadius = NFTCellLayout.cornerRadius
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        
        priceLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        favoriteButton.tintColor = .redUniversal

        cartButton.tintColor = .blackUniversal
        
        [imageView, titleLabel, priceLabel, favoriteButton, cartButton, ratingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // imageView
            imageView .topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView .leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView .heightAnchor.constraint(equalToConstant: NFTCellLayout.imageHeight),
            imageView.widthAnchor.constraint(equalToConstant: NFTCellLayout.imageWidth),
            
            // like (favoriteButton)
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: NFTCellLayout.likeButtonHeight),
            favoriteButton.widthAnchor.constraint(equalToConstant: NFTCellLayout.likeButtonWidth),
            
            // ratingView
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: NFTCellLayout.ratingTopSpacing),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: NFTCellLayout.ratingHeight),
            ratingView.widthAnchor.constraint(equalToConstant: NFTCellLayout.ratingWidth),
            ratingView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: NFTCellLayout.labelTopSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor, constant: NFTCellLayout.labelToCartSpacing),
            
            // priceLabel
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: NFTCellLayout.priceTopSpacing),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor, constant: NFTCellLayout.labelToCartSpacing),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: NFTCellLayout.bottomPadding),
           
            // cartButton
            cartButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: NFTCellLayout.cartButtonTrailing),
            cartButton.widthAnchor.constraint(equalToConstant: NFTCellLayout.cartButtonWidth),
            cartButton.heightAnchor.constraint(equalToConstant: NFTCellLayout.cartButtonHeight)
        ])
    }
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func favoriteTapped() {
        delegate?.nftCellDidTapFavorite(self)
    }
    
    @objc private func cartTapped() {
        delegate?.nftCellDidTapCart(self)
    }
}

