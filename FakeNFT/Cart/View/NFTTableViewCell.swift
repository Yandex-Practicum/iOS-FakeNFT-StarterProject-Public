import UIKit

protocol NFTTableViewCellDelegate: AnyObject {
    func showDeleteView(index: Int)
}

final class NFTTableViewCell: UITableViewCell {
    
    var delegate: NFTTableViewCellDelegate?
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
        deleteFromBasketButton.addTarget(nil, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return deleteFromBasketButton
    }()
    
    private func addViews() {
        [nftImageView, nftNameLabel, nftPriceLabel, nftPrice, nftRatingLabel, deleteFromBasketButton].forEach(setupView(_:))
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftRatingLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftRatingLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPriceLabel.topAnchor.constraint(equalTo: nftRatingLabel.bottomAnchor, constant: 12),
            nftPrice.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftPrice.topAnchor.constraint(equalTo: nftPriceLabel.bottomAnchor, constant: 2),
            deleteFromBasketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteFromBasketButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func didTapDeleteButton() {
        delegate?.showDeleteView(index: indexCell ?? 0)
        print("TAP")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
