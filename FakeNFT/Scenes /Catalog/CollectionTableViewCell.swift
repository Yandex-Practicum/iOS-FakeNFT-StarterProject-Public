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
        label.font = .bodyRegular
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
        // Форматируем текст: "Название (X NFT)"
        let nftCount = collection.nftCount
        let nftText = NSLocalizedString("Catalog.nftCount", value: "NFT", comment: "")
        let titleText = "\(collection.name) (\(nftCount) \(nftText))"
        
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
        
        // Загружаем изображение из Assets
        let image = UIImage(named: collection.cover)
        coverImageView.image = image
        
        // Если изображение найдено, убираем серый фон
        if image != nil {
            coverImageView.backgroundColor = .clear
            print("Successfully loaded local image: \(collection.cover)")
        } else {
            print("Failed to load local image: \(collection.cover)")
            coverImageView.backgroundColor = .lightGray
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
            coverImageView.heightAnchor.constraint(equalToConstant: 179),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.kf.cancelDownloadTask() // отменяем загрузку если ячейка переиспользуется
        coverImageView.image = nil
        coverImageView.backgroundColor = .lightGray
    }
}
