import UIKit
import Kingfisher

final class NFTCell: UITableViewCell, ReuseIdentifying {
    
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "favouritesIcons")
        return imageView
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()
    
    private lazy var starsImage: [UIImageView] = {
        (1...5).map { _ in
            let view = UIImageView()
            view.image = UIImage()
            return view
        }
    }()

    private lazy var starsView: UIStackView = {
        let view = UIStackView(arrangedSubviews: starsImage)
        view.axis = .horizontal
        view.spacing = CGFloat(2)
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    private let authorPrefix: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = NSLocalizedString("NFTCell.from", comment: "")
        return label
    }()
    
    private let author: UILabel = {
        let label = UILabel()
        label.font = .caption2
        return label
    }()
    
    private let authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing = 4
        return stackView
    }()
    
    private let nftDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NFTCell.price", comment: "")
        label.font = .caption2
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStarsState(_ state: Int) {
        starsImage.enumerated().forEach { position, star in
            let color = position < state ? UIColor.nftYellowUniversal : UIColor.nftLightgrey
            star.image = UIImage(named: "stars")?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
    }
    
    func configure(nft: NFT, authorName: String) {
        self.nftImageView.kf.setImage(with: URL(string: nft.images[0]),
                                      placeholder: UIImage(named: "nullImage"))
        self.name.text = nft.name
        self.setStarsState(nft.rating)
        self.author.text = authorName
        
        if let formattedPrice = NumberFormatter.defaultPriceFormatter.string(from: NSNumber(value: nft.price)) {
            self.currentPriceLabel.text = "\(formattedPrice) ETH"
        }
    }
    
    private func setupViews() {
        nftImageView.addViewWithNoTAMIC(likeImageView)
        [authorPrefix, author].forEach { authorStackView.addArrangedSubview($0) }
        [name, starsView, authorStackView].forEach { nftDetailsStackView.addArrangedSubview($0) }
        [priceLabel, currentPriceLabel].forEach { priceStackView.addArrangedSubview($0) }
        [nftImageView, nftDetailsStackView, priceStackView].forEach { contentView.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            nftDetailsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDetailsStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftDetailsStackView.trailingAnchor.constraint(equalTo: priceStackView.leadingAnchor, constant: -60),
            
            author.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: trailingAnchor, multiplier: 988),
            
            priceStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            
            starsView.heightAnchor.constraint(equalToConstant: 12),
            starsView.widthAnchor.constraint(equalToConstant: 68),
        ])
    }
}
