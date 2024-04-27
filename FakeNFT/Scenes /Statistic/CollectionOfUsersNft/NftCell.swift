import UIKit

//MARK: - Protocol
protocol NftCellDelegate: AnyObject {
    func isLiked() -> Bool
    func isOnBasket() -> Bool
}

//MARK: - NftCell
final class NftCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "NftCollectionCell"
    weak var delegate: NftCellDelegate?
    private var nft: NftModel?
    private lazy var nftCellFabric: NftCellFabric = {
        
        let nftCellFabric = NftCellFabric(nft: nft!)
        return nftCellFabric
    }()
    
    //MARK: nftImage
    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.layer.cornerRadius = 12
        nftImageView.clipsToBounds = true
        nftImageView.contentMode = .scaleAspectFill
        return nftImageView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let likeImageActive = UIImage(resource: .likeActive)
        let likeImageInactive = UIImage(resource: .likeNotActive)
        let likeImageView = UIImageView(image: likeImageInactive, highlightedImage: likeImageActive)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(tapGesture)
        return likeImageView
    }()
    
    //MARK: nftInfoStackView
    private lazy var nftInfoStackView: UIStackView = {
        let nftInfoStackView = UIStackView()
        nftInfoStackView.axis = .vertical
        nftInfoStackView.spacing = 4
        return nftInfoStackView
    }()

    private lazy var nftRating: RatingStarsStackView = {
        let nftRating = RatingStarsStackView()
        return nftRating
    }()

    //MARK: bottomStackView
    private lazy var bottomStackView: UIStackView = {
        let bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 4
        return bottomStackView
    }()

    //MARK: leftStackView
    private lazy var leftStackView: UIStackView = {
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.spacing = 4
        return leftStackView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.sfProBold17
        return nameLabel
    }()

    private lazy var costLabel: UILabel = {
        let costLabel = UILabel()
        costLabel.font = UIFont.sfProMedium10
        return costLabel
    }()
    
    //MARK: basketButton
    private lazy var basketImageView: UIImageView = {
        let basketImageActive = UIImage(resource: .addToCart)
        let basketImageInactive = UIImage(resource: .deleteFromCart)
        let basketImageView = UIImageView(image: basketImageInactive, highlightedImage: basketImageActive)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(basketButtonTapped))
        basketImageView.isUserInteractionEnabled = true
        basketImageView.addGestureRecognizer(tapGesture)
        return basketImageView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        activateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - objc Methods
    @objc
    func likeButtonTapped() {
        
    }
    
    @objc
    func basketButtonTapped() {
        
    }
}

// MARK: - Add UI-Elements on View
extension NftCell {
    
    func activateUI() {
        
        backgroundColor = UIColor(resource: .ypWhite)
        activateConstraints()
    }
    
    func setNft(by nft: NftModel) {
        
        self.nft = nft
    }
    
    func activateConstraints() {
        
        //MARK: - Add Views
        //MARK: Base View
        [nftImageView, nftInfoStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: likeImageView
        [likeImageView].forEach {
            nftImageView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: nftInfoStackView
        [nftRating, bottomStackView].forEach {
            nftInfoStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: bottomStackView
        [leftStackView, basketImageView].forEach {
            bottomStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: leftStackView
        [nameLabel, costLabel].forEach {
            leftStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            //MARK: nftImageView
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            //MARK: likeImageView
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeImageView.heightAnchor.constraint(equalToConstant: 40),
            likeImageView.widthAnchor.constraint(equalToConstant: 40),
            
            //MARK: - nftInfoStackView
            nftInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nftInfoStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            
            //MARK: bottomStackView
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            //MARK: nftRating
            nftRating.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
            
            //MARK: leftStackView
            leftStackView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor),
            
            //MARK: nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: leftStackView.leadingAnchor),
            
            //MARK: costLabel
            costLabel.leadingAnchor.constraint(equalTo: leftStackView.leadingAnchor),
            
            //MARK: basketButton
            basketImageView.topAnchor.constraint(equalTo: bottomStackView.topAnchor),
            basketImageView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor),
            basketImageView.heightAnchor.constraint(equalToConstant: 40),
            basketImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureCell(with data: NftModel) {
        nft = data
        
        setAvatar()
        setRating()
        setName()
        setCost()
        setLike()
        setBasket()
    }
}

//MARK: - LoadData
extension NftCell {
    
    func setAvatar() {
        
        let placeholderAvatar = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor(resource: .ypGrayUn), renderingMode: .alwaysOriginal)
        
        let avatarUrl = nftCellFabric.getAvatar()
        nftImageView.kf.setImage(with: avatarUrl, placeholder: placeholderAvatar)
    }
    
    func setRating() {
        
        let ratingNft = nftCellFabric.getRating()
        nftRating.rating = ratingNft
        nftRating.setStars()
    }
    
    func setName() {
        
        let name = nftCellFabric.getName()
        nameLabel.text = name
    }
    
    func setCost() {
        
        let cost = nftCellFabric.getCost()
        costLabel.text = cost
    }
    
    func setLike() {
        
        let isLike = nftCellFabric.isLiked()
        likeImageView.isHighlighted = isLike ? true : false
    }
    
    func setBasket() {
        
        let isBasket = nftCellFabric.isOnBasket()
        basketImageView.isHighlighted = isBasket ? false : true
    }
}
