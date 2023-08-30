import UIKit
import Kingfisher

final class StatisticCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Vars
    private var statisticCellModel: UserResponse? {
        didSet {
            guard let statisticCellModel = statisticCellModel else { return }
            if let url = URL(string: statisticCellModel.avatar) {
                avatarImageView.kf.setImage(with: url)
            }
            nameLabel.text = statisticCellModel.name
            ratingPointsLabel.text = String(statisticCellModel.nfts.count)
        }
    }
    
    // MARK: - UI
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .captionSmallRegular
        label.textColor = .blackDay
        label.textAlignment = .center
        return label
    }()
    
    private lazy var recordView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGrayDay
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .captionLargeBold
        label.textColor = .blackDay
        return label
    }()
    
    private lazy var ratingPointsLabel: UILabel = {
        let label = UILabel()
        label.font = .captionLargeBold
        label.textColor = .blackDay
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ReuseIdentifying Protocol
extension StatisticCollectionViewCell: ReuseIdentifying {
    static var defaultReuseIdentifier = "StatisticCollectionViewCell"
}

extension StatisticCollectionViewCell {
    
    // MARK: - Public Functions
    func setupNumberLabelText(text: String) {
        numberLabel.text = text
    }
    func setupCellUI(model: UserResponse) {
        self.statisticCellModel = model
    }
    
    // MARK: - Private Functions
    private func setupViews() {
        [numberLabel,
         recordView
        ].forEach(contentView.setupView)
        
        [avatarImageView,
         nameLabel,
         ratingPointsLabel
        ].forEach(recordView.setupView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 27),
            
            recordView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 8),
            recordView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recordView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recordView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            avatarImageView.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: ratingPointsLabel.leadingAnchor),
            
            ratingPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingPointsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
