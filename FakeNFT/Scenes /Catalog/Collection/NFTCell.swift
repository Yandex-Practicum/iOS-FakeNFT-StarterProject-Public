import UIKit
import Kingfisher

final class NFTCell: UICollectionViewCell {
    
    static let identifier = "NFTCell"
    
    var likeButtonAction:(() -> Void)?
    var cartButtonAction:(() -> Void)?
            
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "star")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton()
//        button.setImage(UIImage(named: "like"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
//        label.text = "0.004 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
//        button.setImage(UIImage(named: "cart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setRating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [nftImageView, likeButton, ratingStackView, nftNameLabel, priceLabel, cartButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -45),
            nftNameLabel.widthAnchor.constraint(equalToConstant: 68),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -29),
            priceLabel.widthAnchor.constraint(equalToConstant: 68),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setRating() {
        for _ in 0...5 {
            let starImage = UIImageView()
            starImage.image = UIImage(named: "star")
            ratingStackView.addArrangedSubview(starImage)
        }
    }
    
    @objc private func likeButtonTapped() {
        likeButtonAction?()
    }
    
    @objc private func cartButtonTapped() {
        cartButtonAction?()
    }
    
    func configure(nftImage: URL, likeOrDislike: String, rating: Int, nftName: String, pirce: String, cartImage: String, likeButtonInteraction: @escaping () -> Void, cartButtonInteraction: @escaping () -> Void) {
        nftImageView.kf.setImage(with: nftImage)
        likeButton.setImage(UIImage(named: likeOrDislike), for: .normal)
        fillRatingStackView(by: rating)
        nftNameLabel.text = nftName
        priceLabel.text = pirce
        cartButton.setImage(UIImage(named: cartImage), for: .normal)
        likeButtonAction = likeButtonInteraction
        cartButtonAction = cartButtonInteraction
    }
    
    func fillRatingStackView(by rating: Int) {
        guard rating >= 0 && rating <= 5 else {
            assertionFailure("Invalid rating!")
            return
        }
        
        for i in 0..<rating {
            if let starImage = ratingStackView.subviews[i] as? UIImageView {
                starImage.image = UIImage(named: "star_yellow")
            }
        }
    }
}

