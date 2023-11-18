import UIKit

final class CurrencyCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "currencyCollectionViewCell"

    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var currencyFullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .yaGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var currencyNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(currencyFullNameLabel)
        stackView.addArrangedSubview(currencyShortNameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var currencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(currencyImageView)
        stackView.addArrangedSubview(currencyNameStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: CurrencyModel) {
        self.currencyFullNameLabel.text = model.title
        self.currencyShortNameLabel.text = model.name
        self.currencyImageView.kf.setImage(with: URL(string: model.image))
    }

    private func createSubviews() {
        backgroundColor = .clear
        contentView.addSubview(currencyStackView)
        NSLayoutConstraint.activate([
            currencyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currencyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            currencyStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            currencyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36)
            ])
    }
}
