import UIKit

final class ProfileCell: UITableViewCell, ReuseIdentifying {
    static let reuseIdentifier = "ProfileCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "forward")
        imageView.tintColor = .nftBlack
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        self.titleLabel.text = title
    }

    private func setupViews() {
        [arrowImageView, titleLabel].forEach { contentView.addViewWithNoTAMIC($0) }

        NSLayoutConstraint.activate([

            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
