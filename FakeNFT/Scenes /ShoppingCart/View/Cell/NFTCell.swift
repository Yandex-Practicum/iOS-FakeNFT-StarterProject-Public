import UIKit
import Kingfisher

protocol CartCellDelegate {
    func showDeleteView(index: Int)
}

class NFTCell: UITableViewCell {
    
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return pictureImageView.kf.cancelDownloadTask()
            }
            
            pictureImageView.kf.setImage(with: url)
        }
    }
    
    static let reuseIdentifier = "NFTCellReuseIdentifier"
    var delegate: CartCellDelegate?
    var indexCell: Int?
    
    // Элементы для NFT в корзине
    
    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cartDeleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "inCart"), for: .normal)
        button.addTarget(nil, action: #selector(cartDeleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        // Добавляем элементы для корзины NFT
        contentView.addSubview(pictureImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(priceLabelName)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartDeleteButton)
        
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
            
            cartDeleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cartDeleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cartDeleteButton.heightAnchor.constraint(equalToConstant: 40),
            cartDeleteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView.kf.cancelDownloadTask()
        
    }
    
    func configure(with nft: ShoppingCartNFTModel) {
        imageURL = nft.images.first
        
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price)" + " ETH"
        
        for subview in ratingStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for _ in 0..<nft.rating {
            let starImageView = UIImageView(image: UIImage(named: "star_yellow"))
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        for _ in nft.rating..<5 {
            let starImageView = UIImageView(image: UIImage(named: "star"))
            ratingStackView.addArrangedSubview(starImageView)
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
    }
    
    @objc func cartDeleteButtonTapped() {
        delegate?.showDeleteView(index: indexCell ?? 0)
    }
}
