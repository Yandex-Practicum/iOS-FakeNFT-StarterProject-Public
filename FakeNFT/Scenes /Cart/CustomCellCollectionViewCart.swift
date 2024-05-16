import UIKit

final class CustomCellCollectionViewCart: UICollectionViewCell {

    static let reuseIdentifier = "CustomCollectionCellView"

    private let mainView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .segmentInactive
        view.layer.cornerRadius = 12
        return view
    }()

    let imageViews: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .blackUniversal
        image.layer.cornerRadius = 6
        image.image = UIImage(named: "Vector")
        return image
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let shortCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "BTC"
        label.textColor = .greenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        configureConstraits()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell(currencyLabel: String, titleLabel: String) {
        self.currencyLabel.text = titleLabel
        self.shortCurrencyLabel.text = currencyLabel
    }

    func setImage(image: UIImage) {
        imageViews.image = image
    }

    private func configureView() {
        [mainView].forEach {
            contentView.addSubview($0)
        }
        [currencyLabel,
         shortCurrencyLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        [imageViews,
         titleStackView].forEach {
            mainView.addSubview($0)
        }
    }

    private func configureConstraits() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageViews.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            imageViews.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            imageViews.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -5),
            imageViews.widthAnchor.constraint(equalToConstant: 36),

            titleStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            titleStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -5),
            titleStackView.leadingAnchor.constraint(equalTo: imageViews.trailingAnchor, constant: 4)
        ])
    }

}
