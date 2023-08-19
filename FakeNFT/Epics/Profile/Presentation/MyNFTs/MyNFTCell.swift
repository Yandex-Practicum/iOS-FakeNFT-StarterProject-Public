import UIKit

final class MyNFTCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Private properties
    
    private lazy var aboutNFCStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nftNameLabel, ratingStack, byAuthorStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, priceValueLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    private lazy var byAuthorStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [byAuthorLabel, authorLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .bottom
        stack.spacing = 4
        return stack
    }()
    
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        return nftImage
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var byAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .ypBlack
        label.text = NSLocalizedString("nft.by", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = NSLocalizedString("nft.price", comment: "")
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "0 ETH"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        addingUIElements()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in ratingStack.subviews {
            ratingStack.removeArrangedSubview(view)
        }
    }
    
    // MARK: - Public properties
    
    func configure(with model: MyNFTPresentationModel) {
        nftImage.kf.setImage(with: URL(string: model.image))
        nftNameLabel.text = model.nftName
        authorLabel.text = (model.authorName)
        priceLabel.text = NSLocalizedString("nft.price", comment: "")
        priceValueLabel.text = ("\(model.price) NFT")
        setLikeButtonImage(for: model.isLiked)
        ratingStack.setStarsInStack(with: model.rating)
    }
    
    // MARK: - Private methods
    
    private func addingUIElements() {
        [nftImage, aboutNFCStack, priceStack, likeButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            aboutNFCStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            aboutNFCStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            aboutNFCStack.widthAnchor.constraint(equalToConstant: 117),
            
            ratingStack.heightAnchor.constraint(equalToConstant: 12),
            
            priceStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceStack.leadingAnchor.constraint(equalTo: aboutNFCStack.trailingAnchor),
            priceStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -39)
        ])
    }
    
    private func setLikeButtonImage(for state: Bool) {
        let image: UIImage? = state ? .liked : .unliked
        likeButton.setImage(image, for: .normal)
    }
}
