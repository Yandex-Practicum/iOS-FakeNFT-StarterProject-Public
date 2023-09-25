import UIKit

final class DescriptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DescriptionCell"
    
    var authorButtonTapped: (() -> Void)?
    
    private lazy var collectionsNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(named: "ypBlue")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorNameButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(named: "ypBlue"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.titleLabel?.tintColor = UIColor(named: "ypBlue")
        button.addTarget(self, action: #selector(authorNameButtonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [collectionsNameLabel, authorLabel, authorNameLabel, descriptionLabel, authorNameButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionsNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionsNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionsNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.topAnchor.constraint(equalTo: collectionsNameLabel.bottomAnchor, constant: 13),
            
            authorNameLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 5),
            authorNameLabel.bottomAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24),
            
            authorNameButton.topAnchor.constraint(equalTo: collectionsNameLabel.bottomAnchor, constant: 12),
            authorNameButton.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
            authorNameButton.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            authorNameButton.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 4)
        ])
    }
    
    @objc private func authorNameButtonTapped() {
        authorButtonTapped?()
    }
    
    func configure(
        collectionName: String,
        subTitle: String,
        authorName: String,
        description: String,
        authorNameButtonAction: @escaping() -> Void
    ) {
        collectionsNameLabel.text = collectionName
        authorLabel.text = subTitle
        authorNameLabel.text = authorName
        descriptionLabel.text = description
        authorButtonTapped = authorNameButtonAction
    }
}
