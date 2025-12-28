import UIKit
import Kingfisher

final class StatisticTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .yLightGray)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(placeLabel)
        contentView.addSubview(containerView)
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(nftCountLabel)
        
        NSLayoutConstraint.activate([
            placeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeLabel.widthAnchor.constraint(equalToConstant: 27),
            
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: nftCountLabel.leadingAnchor, constant: -8),
            
            nftCountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nftCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        nftCountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - Configuration
    func configure(with user: User, place: Int) {
        placeLabel.text = "\(place)"
        nameLabel.text = user.name
        nftCountLabel.text = "\(user.nfts.count)"
        
        if let url = URL(string: user.avatar) {
            
            let grayPlaceholder = UIImage(systemName: "person.crop.circle.fill")?
                .withTintColor(UIColor(resource: .universalGrey), renderingMode: .alwaysOriginal)
            
            avatarImageView.kf.setImage(
                with: url,
                placeholder: grayPlaceholder,
                options: [.transition(.fade(0.2))]
            )
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor(resource: .universalGrey), renderingMode: .alwaysOriginal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil
    }
}
