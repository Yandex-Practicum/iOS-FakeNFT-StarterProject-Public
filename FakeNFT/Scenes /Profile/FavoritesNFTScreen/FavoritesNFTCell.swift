import UIKit
import Kingfisher

protocol FavoritesNFTCellDelegateProtocol: AnyObject {
    func didTapHeartButton(in cell: FavoritesNFTCell)
}

final class FavoritesNFTCell: UICollectionViewCell, ReuseIdentifying {
    
    weak var delegate: FavoritesNFTCellDelegateProtocol?
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        return label
    }()
    
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyHeartButtonImage")
        return imageView
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
    
    private let nftDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "filledHeartButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func likeButtonTapped() {
        delegate?.didTapHeartButton(in: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    func configure(with viewModel: FavoritesNFTCellViewModel) {
        self.nftImageView.kf.setImage(with: viewModel.imageUrl,
                                      placeholder: UIImage(named: "nullImage"))
        self.setStarsState(viewModel.formattedRating)
        self.name.text = viewModel.title
        self.currentPriceLabel.text = viewModel.formattedPrice
    }
    
    private func setupViews() {
        [name, starsView, currentPriceLabel].forEach { nftDetailsStackView.addArrangedSubview($0) }
        [nftImageView, nftDetailsStackView, likeButton].forEach { contentView.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            nftDetailsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDetailsStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }
}
