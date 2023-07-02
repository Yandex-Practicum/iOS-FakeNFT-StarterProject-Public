import UIKit

final class MyNFTCell: UITableViewCell {
    
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
    
    var nftAuthor: UILabel = {
        let nftName = UILabel()
        nftName.translatesAutoresizingMaskIntoConstraints = false
        nftName.font = .systemFont(ofSize: 13)
        nftName.textColor = .black
        return nftName
    }()
    
    var nftPriceStack: UIStackView = {
        let nftPriceStack = UIStackView()
        nftPriceStack.translatesAutoresizingMaskIntoConstraints = false
        nftPriceStack.axis = .vertical
        nftPriceStack.distribution = .equalSpacing
        nftPriceStack.alignment = .leading
        nftPriceStack.spacing = 2
        return nftPriceStack
    }()
    
    var nftPriceLabel: UILabel = {
        let nftPriceLabel = UILabel()
        nftPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        nftPriceLabel.font = .systemFont(ofSize: 13)
        nftPriceLabel.text = "Цена"
        return nftPriceLabel
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addImage()
        addNFTStack()
        addNFTPriceStack()
        addFavoriteButton()
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
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108)
        ])
    }
    
    func addFavoriteButton() {
        contentView.addSubview(nftFavorite)
        NSLayoutConstraint.activate([
            nftFavorite.topAnchor.constraint(equalTo: nftImage.topAnchor),
            nftFavorite.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            nftFavorite.heightAnchor.constraint(equalToConstant: 42),
            nftFavorite.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func addNFTStack() {
        contentView.addSubview(nftStack)
        nftStack.addArrangedSubview(nftName)
        nftStack.addArrangedSubview(nftRating)
        nftStack.addArrangedSubview(nftAuthor)
        NSLayoutConstraint.activate([
            nftStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 144),
            nftStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -88),
            nftRating.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func addNFTPriceStack() {
        contentView.addSubview(nftPriceStack)
        nftPriceStack.addArrangedSubview(nftPriceLabel)
        nftPriceStack.addArrangedSubview(nftPriceValue)
        NSLayoutConstraint.activate([
            nftPriceStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftPriceStack.leadingAnchor.constraint(equalTo: nftStack.trailingAnchor)
        ])
    }
}

extension MyNFTCell: ReuseIdentifying {}
