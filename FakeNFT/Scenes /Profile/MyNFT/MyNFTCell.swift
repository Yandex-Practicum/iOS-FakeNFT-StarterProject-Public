import UIKit

final class MyNFTCell: UITableViewCell, ReuseIdentifying {
    var tapAction: (() -> Void)?
    
    private lazy var nftImage = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nftStack = {
        let sackView = UIStackView()
        sackView.axis = .vertical
        sackView.distribution = .equalSpacing
        sackView.alignment = .leading
        sackView.spacing = 4
        return sackView
    }()
    
    private lazy var nftName = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var nftRating: StarRatingController = {
        let starRating = StarRatingController(starsRating: 5)
        return starRating
    }()
    
    private lazy var nftAuthor = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var nftPriceStack = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var nftPriceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "Цена"
        return label
    }()
    
    private lazy var nftPriceValue = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.text = "0 ETH"
        return label
    }()
    
    private lazy var nftFavorite = {
        let button = FavoriteButton()
        button.addTarget(self, action: #selector(self.didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: CellModel) {
        nftImage.kf.setImage(with: URL(string: model.image))
        nftName.text = model.name
        nftRating.setStarsRating(rating: model.rating)
        nftAuthor.text = "от \(model.author)"
        nftPriceValue.text = "\(model.price) ETH"
        nftFavorite.isFavorite = model.isFavorite
        nftFavorite.nftID = model.id
    }
    
    @objc
    private func didTapFavoriteButton(_ sender: FavoriteButton) {
        sender.isFavorite.toggle()
        if let tapAction = tapAction { tapAction() }
    }
    
    private func setupConstraints(){
        [nftImage, nftFavorite, nftStack, nftPriceStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [nftName, nftRating, nftAuthor].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            nftStack.addArrangedSubview($0)
        }
        
        [nftPriceLabel, nftPriceValue].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            nftPriceStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            nftFavorite.topAnchor.constraint(equalTo: nftImage.topAnchor),
            nftFavorite.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            nftFavorite.heightAnchor.constraint(equalToConstant: 42),
            nftFavorite.widthAnchor.constraint(equalToConstant: 42),
            
            nftStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftStack.widthAnchor.constraint(equalToConstant: 117),
            
            nftRating.heightAnchor.constraint(equalToConstant: 12),
            
            nftPriceStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftPriceStack.leadingAnchor.constraint(equalTo: nftStack.trailingAnchor),
            nftPriceStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -39)
        ])
    }
}

extension MyNFTCell {
    struct CellModel {
        let image: String
        let name: String
        let rating: Int
        let author: String
        let price: Float
        let isFavorite: Bool
        let id: String
    }
}
