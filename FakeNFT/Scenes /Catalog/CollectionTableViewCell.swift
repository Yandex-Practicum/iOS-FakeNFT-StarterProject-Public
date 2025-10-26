import UIKit
import Kingfisher

final class CollectionTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with collection: NFTCollection) {
        let nftCount = collection.nfts.count
        let nftText = NSLocalizedString("Catalog.nftCount", value: "NFT", comment: "")
        let titleText = "\(collection.name) (\(nftCount))"
        
        // Создаем атрибутивную строку для разного форматирования
        let attributedString = NSMutableAttributedString(string: titleText)
        
        // Находим диапазон количества NFT
        if let nftRange = titleText.range(of: "(\(nftCount) \(nftText))") {
            let nsRange = NSRange(nftRange, in: titleText)
            
            // Применяем жирный шрифт для количества NFT
            attributedString.addAttribute(.font, value: UIFont.bodyBold, range: nsRange)
        }
        
        titleLabel.attributedText = attributedString
        
        // Загружаем изображение коллекции
        loadCoverImage(for: collection)
    }
    
    private func loadCoverImage(for collection: NFTCollection) {
        // Сбрасываем изображение перед загрузкой нового
        coverImageView.image = nil
        coverImageView.backgroundColor = .lightGray
        
        if let coverURL = collection.coverURL {
            coverImageView.backgroundColor = .lightGray
            
            coverImageView.kf.setImage(
                with: coverURL,
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.coverImageView.backgroundColor = .clear
                        print("Successfully loaded image from: \(coverURL)")
                    case .failure(let error):
                        self?.coverImageView.backgroundColor = .lightGray
                        print("Failed to load image from: \(coverURL), error: \(error)")
                    }
                }
            }
        } else {
            coverImageView.backgroundColor = .lightGray
            print("Invalid cover URL for collection: \(collection.name)")
        }
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverImageView.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.kf.cancelDownloadTask()
        coverImageView.image = nil
        coverImageView.backgroundColor = .lightGray
    }
}
