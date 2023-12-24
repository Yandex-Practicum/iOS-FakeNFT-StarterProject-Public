import UIKit

final class PaymentTypeCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PaymentTypeCollectionViewCell"
    
    //MARK: - Computed properties
    
    private lazy var layerView: UIView = {
        let view = UIView()
        view.backgroundColor = .nftLightGray
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .nftBlack
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var shortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .nftGreenUniversal
        label.textAlignment = .left
        
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        addSubviews()
        constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            layer.cornerRadius = 12
            layer.borderWidth = isSelected ? 1.0 : 0.0
            layer.borderColor = UIColor.nftBlack?.cgColor
        }
    }
    
    //MARK: - Private methods
    
    private func addSubviews() {
        contentView.addSubview(layerView)
        
        [imageView,
         fullNameLabel,
         shortNameLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            layerView.addSubview($0)
        }
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            layerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            layerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            layerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            layerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: layerView.leadingAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: layerView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: layerView.bottomAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            
            fullNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            fullNameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            shortNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            shortNameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            shortNameLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    //MARK: - Public methods
    
    func configureCell(fullName: String, shortName: String, image: UIImage?) {
        if let image {
            fullNameLabel.text = fullName
            shortNameLabel.text = shortName
            imageView.image = image
        }
    }
}
