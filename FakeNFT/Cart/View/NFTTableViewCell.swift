import UIKit

protocol NFTTableViewCellDelegate: AnyObject {
    func showDeleteView(index: Int)
}

final class NFTTableViewCell: UITableViewCell {
    
    public weak var delegate: NFTTableViewCellDelegate?
    var indexCell: Int?
    static let identifier = "NFTTableViewCell"

    private lazy var nftImageView: UIImageView = {
        let nftImageView = UIImageView()
        nftImageView.image = UIImage(named: "mockImageNft")
        return nftImageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let nftNameLabel = UILabel()
        nftNameLabel.text = "April"
        nftNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nftNameLabel
    }()
    
    private lazy var nftRatingLabel: UIImageView = {
        let nftRatingLabel = UIImageView()
        nftRatingLabel.image = UIImage(named: "ratingStarNft")
        return nftRatingLabel
    }()
    
    private lazy var nftRatingStack: UIStackView = {
        let nftRatingStack = UIStackView()
        nftRatingStack.axis = .horizontal
        nftRatingStack.spacing = 4
        nftRatingStack.distribution = .fillEqually
        return nftRatingStack
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let nftPriceLabel = UILabel()
        nftPriceLabel.text = "Цена"
        nftPriceLabel.font = UIFont.systemFont(ofSize: 13)
        return nftPriceLabel
    }()
    
    private lazy var nftPrice: UILabel = {
        let nftPrice = UILabel()
        nftPrice.text = "1,78 ETH"
        nftPrice.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return nftPrice
    }()
    
    private lazy var deleteFromBasketButton: UIButton = {
        let deleteFromBasketButton = UIButton()
        deleteFromBasketButton.setImage(UIImage(named: "deleteButton"), for: .normal)
        deleteFromBasketButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        deleteFromBasketButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteFromBasketButton
    }()
    
    private func addViews() {
        [nftImageView, nftNameLabel, nftPriceLabel, nftPrice, nftRatingStack, deleteFromBasketButton].forEach(setupView(_:))
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftRatingStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftRatingStack.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPriceLabel.topAnchor.constraint(equalTo: nftRatingStack.bottomAnchor, constant: 12),
            nftPrice.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPrice.topAnchor.constraint(equalTo: nftPriceLabel.bottomAnchor, constant: 2),
            deleteFromBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteFromBasketButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    func configureCell(with model: MockNFTModel) {
        nftImageView.image = model.image
        nftPrice.text = "\(model.price)" + "ETH"
        nftNameLabel.text = model.name
        
        let rating = model.rating
    
        for _ in 0...rating - 1 {
            let ratingStar = UIImageView(image: UIImage(named: "ratingStarNft"))
            nftRatingStack.addArrangedSubview(ratingStar)
        }
        for _ in rating..<5 {
            let emptyStar =  UIImageView(image: UIImage(named: "emptyStarNft"))
            nftRatingStack.addArrangedSubview(emptyStar)
        }
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        delegate?.showDeleteView(index: indexCell ?? 0)
        print("TAP")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NFTTableViewCell.identifier)
        addViews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
