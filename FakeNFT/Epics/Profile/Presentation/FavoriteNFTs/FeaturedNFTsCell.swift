import UIKit

final class FeaturedNFTCell: UICollectionViewCell, ReuseIdentifying {
    static let defaultReuseIdentifier: String = "FavoritesNFTCell"
    // MARK: - Private properties
    private lazy var aboutNFCStack: UIStackView = {
        let nftStack = UIStackView()
        nftStack.translatesAutoresizingMaskIntoConstraints = false
        nftStack.axis = .vertical
        nftStack.distribution = .equalSpacing
        nftStack.alignment = .leading
        nftStack.spacing = 4
        return nftStack
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        return nftImage
    }()
    
    private lazy var favoriteNFTButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular
        label.textColor = .black
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = NSLocalizedString("nft.price", comment: "")
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "0 ETH"
        return label
    }()

    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addingUIElements()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    func configureCell() {
        nftImage.image = .mockCell
        nftNameLabel.text = "Имя NFT"
        priceLabel.text = "10 ETH"
        setImageForButton(isFavorite: true)
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        [nftImage, aboutNFCStack, favoriteNFTButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        [nftNameLabel, ratingStack, priceLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            aboutNFCStack.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            favoriteNFTButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: -6),
            favoriteNFTButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 6),
            favoriteNFTButton.heightAnchor.constraint(equalToConstant: 42),
            favoriteNFTButton.widthAnchor.constraint(equalToConstant: 42),
            
            aboutNFCStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            aboutNFCStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            aboutNFCStack.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setImageForButton(isFavorite: Bool) {
        let image = isFavorite ? UIImage.unliked : UIImage.liked
        favoriteNFTButton.setImage(image, for: .normal)
    }
}
