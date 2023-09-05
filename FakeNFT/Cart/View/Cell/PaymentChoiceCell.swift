import UIKit

final class PaymentChoiceCell: UICollectionViewCell {
    static let identifier = "PaymentChoiceCell"
    
    private lazy var collectionView: UIView = {
        let collectionView = UIView()
        collectionView.backgroundColor = .ypLightGrey
        collectionView.layer.cornerRadius = 12
        collectionView.layer.masksToBounds = true
        return collectionView
    }()
    
    lazy var payMethodImage: UIImageView = {
        let payMethodImage = UIImageView()
        payMethodImage.image = UIImage(named: "bitcoin")
        return payMethodImage
    }()
    
    lazy var firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.textColor = .ypBlack
        return firstLabel
    }()
    
    lazy var secondLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.textColor = .ypGreen
        return secondLabel
    }()
    
    private func addView() {
        [collectionView, payMethodImage, firstLabel, secondLabel].forEach(contentView.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            payMethodImage.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 4),
            payMethodImage.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 12),
            payMethodImage.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -4),
            firstLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 4),
            firstLabel.leadingAnchor.constraint(equalTo: payMethodImage.trailingAnchor, constant: 4),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor),
            secondLabel.leadingAnchor.constraint(equalTo: payMethodImage.trailingAnchor, constant: 4),
            secondLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -4)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addView()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
