import UIKit

class NFTCell: UITableViewCell {
    static let reuseIdentifier = "NFTCellReuseIdentifier"

    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cartImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabelName: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Цена"
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        // Добавьте pictureImageView, nameLabel, ratingLabel и priceLabel в contentView ячейки.
        // Установите правильные ограничения для каждого из них.
        contentView.addSubview(pictureImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(priceLabelName)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartImageView)
        
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pictureImageView.widthAnchor.constraint(equalToConstant: 108),
            pictureImageView.heightAnchor.constraint(equalToConstant: 108),
            pictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 100),
            
            priceLabelName.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            priceLabelName.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 20),
            priceLabelName.widthAnchor.constraint(equalToConstant: 100),
            
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            priceLabel.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 20),
            priceLabel.heightAnchor.constraint(equalToConstant: 22),
            priceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            cartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            cartImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cartImageView.heightAnchor.constraint(equalToConstant: 19),
            cartImageView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    

    func configure(with nft: NFT) {
        pictureImageView.image = nft.picture
        nameLabel.text = nft.name
        ratingLabel.text = "Rating: \(nft.rating)"
        priceLabel.text = "\(nft.price)" + " ETH"
    }
}
