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
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        contentView.addSubview(ratingStackView)
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
            
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 20),
            
            priceLabelName.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 12),
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
        priceLabel.text = "\(nft.price)" + " ETH"
        
        // Очищаем стек предыдущих звездочек
        for subview in ratingStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        // Создаем новые звездочки в соответствии с рейтингом
        for _ in 0..<nft.rating {
            let starImageView = UIImageView(image: UIImage(named: "starActive"))
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        for _ in nft.rating..<5 {
            let starImageView = UIImageView(image: UIImage(named: "starInactive"))
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }
}
