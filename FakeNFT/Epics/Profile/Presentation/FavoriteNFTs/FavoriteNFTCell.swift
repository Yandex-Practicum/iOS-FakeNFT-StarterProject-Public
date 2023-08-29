import UIKit

final class FavoriteNFTCell: UICollectionViewCell & ReuseIdentifying {
    // MARK: - Public properties
    
    static let identifier: String = "FavoriteNFTCell"
    weak var delegate: FavoriteNFTCellDelegate?
    
    // MARK: - Private properties
    
    private var indexPath: IndexPath?
    private lazy var aboutNFCStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nftNameLabel, ratingStack, priceLabel])
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
    
    private lazy var nftImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.liked, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
        label.font = .caption1
        label.text = "0 ETH"
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
    
    // MARK: - Public methods
    
    func configureCell(with model: MyNFTPresentationModel, indexPath: IndexPath) {
        self.indexPath = indexPath
        nftImage.kf.setImage(with: URL(string: model.image))
        nftNameLabel.text = model.nftName
        priceLabel.text = ("\(model.price) NFT")
        ratingStack.setStarsInStack(with: model.rating)
    }
    
    // MARK: - Private methods
    
    private func addingUIElements() {
        [nftImage, aboutNFCStack, likeButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            nftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 6),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            aboutNFCStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            aboutNFCStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            aboutNFCStack.heightAnchor.constraint(equalToConstant: 66),
            aboutNFCStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func likeButtonTapped() {
        if let indexPath = indexPath {
            delegate?.didTapLikeButton(at: indexPath)
        }
    }
}
