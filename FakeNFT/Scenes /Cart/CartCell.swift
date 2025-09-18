import UIKit
import Cosmos

final class CartCell: UITableViewCell {
    
    weak var delegate: CartCellDelegate?
    
    let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let starRating: CosmosView = {
        let stars = CosmosView()
        stars.settings.totalStars = 5
        stars.settings.fillMode = .precise
        stars.settings.updateOnTouch = false
        stars.settings.filledColor = .starRatingColor
        stars.settings.emptyColor = .segmentInactive
        stars.settings.starSize = 12
        stars.settings.starMargin = 1
        return stars
    }()
    
    let nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .segmentActive
        return label
    }()
    
    let priceLabel: UILabel = {
       let label = UILabel()
        label.font = .bodyRegular
        label.textColor = .segmentActive
        label.text = "Цена"
        return label
    }()
    let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .segmentActive
        return label
    }()
    let deleteNftButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(resource: .deleteFromCart), for: .normal)
        return button
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubviews(nftImageView, starRating, nftNameLabel, priceLabel, nftPriceLabel, deleteNftButton)
        deleteNftButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            nftNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            starRating.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            starRating.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            priceLabel.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            nftPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            deleteNftButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteNftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteNftButton.heightAnchor.constraint(equalToConstant: 40),
            deleteNftButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    @objc private func deleteButtonTapped() {
        delegate?.cellDidTapDelete(cell: self)
    }
}

