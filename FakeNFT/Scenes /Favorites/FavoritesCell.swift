import UIKit

final class FavoritesCell: UICollectionViewCell {
    
    //MARK: - Layout elements
    var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        return nftImage
    }()
    
    var nftStack: UIStackView = {
        let nftStack = UIStackView()
        nftStack.translatesAutoresizingMaskIntoConstraints = false
        nftStack.axis = .vertical
        nftStack.distribution = .equalSpacing
        nftStack.alignment = .leading
        nftStack.spacing = 4
        return nftStack
    }()
    
    var nftName: UILabel = {
        let nftName = UILabel()
        nftName.translatesAutoresizingMaskIntoConstraints = false
        nftName.font = .boldSystemFont(ofSize: 17)
        nftName.textColor = .black
        return nftName
    }()
    
    var nftRating: StarRatingController = {
        let nftRating = StarRatingController(starsRating: 5)
        nftRating.translatesAutoresizingMaskIntoConstraints = false
        return nftRating
    }()
    
    var nftPriceValue: UILabel = {
        let nftPriceValue = UILabel()
        nftPriceValue.translatesAutoresizingMaskIntoConstraints = false
        nftPriceValue.font = .boldSystemFont(ofSize: 17)
        nftPriceValue.text = "0 ETH"
        return nftPriceValue
    }()
    
    var nftFavorite: FavoriteButton = {
        let nftFavorite = FavoriteButton()
        nftFavorite.translatesAutoresizingMaskIntoConstraints = false
        return nftFavorite
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addImage()
        addFavoriteButton()
        addNFTStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout methods
    func addImage() {
        contentView.addSubview(nftImage)
        nftImage.image = UIImage(named: "UserImagePlaceholder")
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func addFavoriteButton() {
        contentView.addSubview(nftFavorite)
        NSLayoutConstraint.activate([
            nftFavorite.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: -6),
            nftFavorite.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 6),
            nftFavorite.heightAnchor.constraint(equalToConstant: 42),
            nftFavorite.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func addNFTStack() {
        contentView.addSubview(nftStack)
        nftStack.addArrangedSubview(nftName)
        nftStack.addArrangedSubview(nftRating)
        nftStack.addArrangedSubview(nftPriceValue)
        NSLayoutConstraint.activate([
            nftStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            nftRating.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}

extension FavoritesCell: ReuseIdentifying {}
