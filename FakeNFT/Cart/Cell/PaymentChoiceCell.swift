import UIKit
import Kingfisher

final class PaymentChoiceCell: UICollectionViewCell {
    static let identifier = "PaymentChoiceCell"
    
    var currencyModel: CurrencyModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addView()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deselectedCell()
    }
    
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return payMethodImage.kf.cancelDownloadTask()
            }
            
            payMethodImage.kf.setImage(with: url)
        }
    }
    
    private lazy var collectionView: UIView = {
        let collectionView = UIView()
        collectionView.backgroundColor = .ypLightGrey
        collectionView.layer.cornerRadius = 12
        collectionView.layer.masksToBounds = true
        return collectionView
    }()
    
    private lazy var payMethodImage: UIImageView = {
        let payMethodImage = UIImageView()
        payMethodImage.image = UIImage(named: "bitcoin")
        return payMethodImage
    }()
    
    private let payMethodBackgorundImage: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .ypBlack
        return view
    }()
    
    private lazy var firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.textColor = .ypBlack
        firstLabel.font = .caption2
        return firstLabel
    }()
    
    private lazy var secondLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.textColor = .ypGreen
        secondLabel.font = .caption2
        return secondLabel
    }()
    
    private func addView() {
        [collectionView,payMethodBackgorundImage, payMethodImage, firstLabel, secondLabel].forEach(contentView.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            payMethodBackgorundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            payMethodBackgorundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            payMethodBackgorundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            payMethodBackgorundImage.widthAnchor.constraint(equalToConstant: 36),
            payMethodBackgorundImage.heightAnchor.constraint(equalToConstant: 36),
            payMethodImage.centerXAnchor.constraint(equalTo: payMethodBackgorundImage.centerXAnchor),
            payMethodImage.centerYAnchor.constraint(equalTo: payMethodBackgorundImage.centerYAnchor),
            payMethodImage.heightAnchor.constraint(equalToConstant: 31),
            payMethodImage.widthAnchor.constraint(equalToConstant: 31),
            firstLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 4),
            firstLabel.leadingAnchor.constraint(equalTo: payMethodBackgorundImage.trailingAnchor, constant: 4),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 1),
            secondLabel.leadingAnchor.constraint(equalTo: payMethodBackgorundImage.trailingAnchor, constant: 4),
            secondLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -4)
        ])
    }
   
    
    func configureCell(model: CurrencyModel) {
        currencyModel = model
        imageURL = model.image
        firstLabel.text = model.title
        secondLabel.text = model.name
    }
    
    func selectedCell() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.ypBlack?.cgColor
    }
    
    func deselectedCell() {
        contentView.layer.borderWidth = 0.0
    }
}
