import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    static let identifier = "cartCellID"
    var indexCell: Int?
    weak var delegate: CartCellDelegate?
    var imageURL: URL? {
        didSet {
            guard let imageURL = imageURL else {
              return nftImageView.kf.cancelDownloadTask()
            }
            nftImageView.kf.setImage(with: imageURL)
        }
    }
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "AppIcon")
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size17
        label.text = "April"
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Regular.size13
        label.text = "Цена"
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let starView: StarView = {
        let view = StarView()
        view.rating = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size17
        label.text = "1,78 ETH"
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func deleteButtonTapped() {
        delegate?.didTapDeleteButton(at: indexCell ?? 0)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: prepare cell for reuse
    }
    func configureCell(with nft: NFTCartModel) {
        contentView.backgroundColor = .systemBackground

        self.imageURL = nft.images.first
        self.nftNameLabel.text = nft.name
        self.starView.rating =  nft.rating
        self.nftPriceLabel.text = "\(nft.price) ETH"
    }
    func addSubviews() {
        addSubview(contentView)
        addSubview(nftImageView)
        addSubview(nftNameLabel)
        addSubview(nftPriceTitleLabel)
        addSubview(starView)
        addSubview(nftPriceLabel)
        addSubview(deleteButton)
    }
    func setConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            starView.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            starView.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            starView.heightAnchor.constraint(equalToConstant: 12),
            nftPriceTitleLabel.topAnchor.constraint(equalTo: starView.bottomAnchor, constant: 12),
            nftPriceTitleLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            nftPriceTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            nftPriceLabel.topAnchor.constraint(equalTo: nftPriceTitleLabel.bottomAnchor, constant: 2),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
