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
        // TODO: Заменить на реальные URL из API когда будут доступны
        // Временно используем локальные ассеты из Figma
        let coverImageName = getLocalCoverImageName(for: collection.name)
        coverImageView.image = UIImage(named: coverImageName)
        
        // Если есть реальный URL, используем его (раскомментировать когда API будет готово)
        /*
        if let url = URL(string: collection.cover.absoluteString) {
            coverImageView.kf.setImage(with: url)
        }
        */
    }
    
    private func getLocalCoverImageName(for collectionName: String) -> String {
        // Временная логика для демонстрации - сопоставляем названия коллекций с ассетами
        // TODO: Заменить на реальную логику когда будет API
        let availableImages = ["Beige", "Blue", "Broun", "Gray", "Green", "Peach", "Pink", "White", "Yellow"]
        let index = abs(collectionName.hash) % availableImages.count
        return availableImages[index]
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
}
